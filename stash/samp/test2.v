`include "wheel_speed.v"
`include "uart_param.v"
`include "uart_receiver.v"
`include "coordinate_calculation.v"
`default_nettype none
module top (
input      CLK,
output reg uart_txd,//uart_tx
input wire uart_rx,
input wire signalA, //количество тиков будем получать с канала А для первой скорости
input wire signalB,
output reg [7:0] rx_byte_parametrs_r1,
output wire [7:0] pulses_namber,
output wire [7:0] x
);

//reg     [7:0]    pulses_namber; 
//reg              transm_rdy; 
reg     [7:0]    data;
//reg              data_rdy = 1'b0;

//reg  [7:0] rx_byte_parametrs;
//reg  [7:0] rx_byte_parametrs_r1;
reg  [7:0] rx_byte_parametrs_r2;
//reg 	   uart_received;
reg        start = 1'b1;
wire tx;
wire transm_rdy;
//wire [7:0] pulses_namber;
wire rst_flag;
//wire [7:0] x;
wire [7:0] y;
uart_param_trans ut (CLK,data,data_rdy,tx,transm_rdy);
pulses_counter pk (CLK, signalA,  pulses_namber);
coordinate_calculation pc(clk, pulses_namber, pulses_namber, rx_byte_parametrs_r1, rx_byte_parametrs_r2, x, y);
//coordinate_calculation cc(CLK, pulses_namber, pulses_namber, rx_byte_parametrs_r1, rx_byte_parametrs_r2);

reg [1:0]  state = 2'b00; 	// Регистр, который будет менять значение в зависимости от состояния нашего модуля 

assign tx = uart_txd;
wire uart_is_receiving;
wire uart_received = 1'd1;

wire [7:0] rx_byte_parametrs = 8'd127;
//uart_receiver uart1(CLK, uart_rst, uart_rx, uart_received, rx_byte_parametrs, uart_is_receiving, uart_error);

always @(posedge CLK) begin
	rx_byte_parametrs_r1 <= rx_byte_parametrs;
	rx_byte_parametrs_r2 <= rx_byte_parametrs;
    // if(uart_received == 1'd1) begin
    //     rx_byte_parametrs_r1 <= rx_byte_parametrs;
    // end
  	if (start)
  	begin
  	  //pulses_namber <= 8'd0;
  	  start = 1'b0;
  	  data <= 1'd0;
	  data_rdy <= 1'b1;
	  rx_byte_parametrs_r1 <= 1'b0;
  	end
	if (transm_rdy == 1'b1) begin
        data <= pulses_namber;
        data_rdy <= 1'b1;
    end
    else begin
        data_rdy <= 1'b0;
    end

end
endmodule
       