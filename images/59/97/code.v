module top_module(out, zeroflag_out, input_a, input_b);input[31:0] input_a, input_b;
output reg[31:0] out;
output zeroflag_out;

reg carryout;

wire and_1_val;

always @ (input_a or input_b)
begin
 {carryout, out} = input_a + input_b;
end

and and_1(and_1_val, out, 8'b0);
not inv_1(zeroflag_out, and_1_val);endmodule