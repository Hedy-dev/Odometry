
`include "Multiplication.v"
`include "Addition-Subtraction.v"
`include "Iteration.v"
module multiplication_tb;

reg [31:0] a_operand,b_operand;
wire Exception;
wire [31:0] result;

reg clk = 1'b1;

Division DUT(a_operand,b_operand,Exception,result);

always clk = #5 ~clk;

initial
begin

iteration (32'h414DD70A,32'h3F800000,1'b0,32'h00000000,`__LINE__); 

iteration (32'h42A60000,32'h46C1C000,1'b0,32'h414D_D70A,`__LINE__);

$stop;

end

task iteration(
input [31:0] operand_a,operand_b,
input Expected_Exception,
input [31:0] Expected_result,
input integer linenum 
);
begin
@(negedge clk)
begin
	a_operand = operand_a;
	b_operand = operand_b;
end

@(posedge clk)
begin
if (Expected_result == result)
	$display ("Test Passed - %d",linenum, "Result = %h", result);

else
	$display ("Test failed - Expected_result = %h, Result = %h \n Expected_Exception = %d, Exception = %d,\n",Expected_result,result,Expected_Exception,Exception,linenum);
end
end
endtask
endmodule