module top_module(
    input [31:0] in1, 
    input [31:0] in2, 
    output [31:0] out);wire [63:0] result;

assign result = $signed({1'b0,in1}) * $signed (in2);
assign out = result[63:32];

endmodule