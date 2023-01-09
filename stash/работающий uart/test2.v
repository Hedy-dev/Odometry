`include "uart_param.v"
module top (
input  clk,
output LED0,
output LED1,
output LED2,
output LED3,
output LED4,
output LED5,
output LED6,
output LED7,
output uart_txd //uart_tx
);


reg transm_rdy;
reg uart_txd;
reg [7:0] data;
reg data_rdy;
//uart_tx ut(clk, resetn, uart_txd_module, uart_tx_busy, uart_tx_en, uart_tx_data);
uart_param_trans ut (clk,data,data_rdy,tx,transm_rdy);
always @(posedge clk) begin
    if (transm_rdy == 1'b1) begin
        data <= 8'd254;
        data_rdy <= 1'b1;
    end
    else begin
        data_rdy <= 1'b0;
    end
end

assign tx = uart_txd;
//assign LED0 = uart_tx_busy; 
// assign LED1 =  ind[0];
// assign LED2 =  ind[1];
// assign LED3 =  ind[2];
// assign LED4 =  ind[3];
// assign LED5 =  ind[4];
// assign LED6 =  ind[5];
assign LED7 = data_rdy;

endmodule
