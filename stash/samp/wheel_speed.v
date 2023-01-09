module pulses_counter (
input   wire      CLK,
input   wire      signal, //количество тиков будем получать с канала А
output  reg [7:0] pulses_namber
);

reg [21:0]  pulses_clk;
reg         start = 1'b1;
reg rst_flag;
always @(posedge CLK) begin
  if (start)
  begin
    pulses_namber <= 8'd0;
    start <= 1'b0;
    rst_flag <= 1'b0;
  end

  if (pulses_clk < 22'd200000) begin
      rst_flag <= 1'b0;
      pulses_clk <= pulses_clk + 22'd1;
  end
  if (pulses_clk == 22'd200000) begin
     rst_flag <= 1'b1;
     pulses_clk <= 22'd0;
  end
  pulses_clk = pulses_clk + 22'd1;
end

always @(posedge  signal) begin
  pulses_namber <= pulses_namber + 8'd1;
  if (pulses_clk == 22'd200000) begin
    pulses_namber <= 8'd0;
  end
end

endmodule