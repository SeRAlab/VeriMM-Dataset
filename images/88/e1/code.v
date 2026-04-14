module top_module(
	input [3:0]a,b,
	input carry_in,
	output reg [3:0]sum,
	output reg carry_out
	);always @(*)
begin
    sum = a + b + carry_in;
    carry_out = 1'b0;
    if (sum > 9) 
    begin
        sum = sum + 4'b0110;
        carry_out =1'b1;
    end
end
endmodule