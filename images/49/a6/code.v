module top_module(
 input [15:0] immediate,
 input Extsel,
 output [31:0] Eximmidiate 
);assign Eximmidiate[15:0]=immediate;
assign Eximmidiate[31:16]=Extsel?(immediate[15] ? 16'hffff : 16'h0000) : 16'h0000;
endmodule