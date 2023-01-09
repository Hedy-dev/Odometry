module pulses_counter_left (
input         CLK,
input         signalA, // количество тиков будем получать с канала А
output        pulses_namber

);

reg         rst_flag;
reg [21:0]  pulses_clk;
reg [7:0]  pulses_encdr = 0; // подсчет импульсов
reg [7:0]  pulses_namber_r = 0; 
wire signalA;
reg data_rdy;
assign  pulses_namber_r = pulses_namber;
//assign  data_rdy_r = data_rdy;

always @(posedge CLK) begin
  if (pulses_clk < 22'd2000000) begin
    rst_flag <= 1'b0;
    pulses_clk <= pulses_clk + 21'd1;
    data_rdy <= 1'b0;
  end
  if (pulses_clk == 22'd2000000) begin
    rst_flag <= 1'b1;
    pulses_clk <= 22'd0;
    pulses_namber <=  pulses_encdr;
    data_rdy <= 1'b1;
  end
  
end
// текущее колличество импульсов
always @(negedge signalA) begin
  pulses_encdr <= pulses_encdr + 8'd1;
  if (pulses_clk > 22'd1999995) begin
      pulses_encdr <= 8'd0;
  end
end


endmodule