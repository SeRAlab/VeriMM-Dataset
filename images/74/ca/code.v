module top_module(
    input clk,
    input d,
    input [31:0] in,
    output reg q,
    output [31:0] out_xor,
    output [31:0] out_and,
    output [31:0] out_final
 );// D flip-flop using T flip-flop
 reg t;
 always @(posedge clk) begin
    t <= d;
 end
 always @(posedge clk) begin
    q <= t;
 end

 // Combinational circuit for bit-wise XOR and AND
 assign out_xor = in[31:16] ^ in[15:0];
 assign out_and = in[31:16] & in[15:0];

 // Bit-wise OR operation
 assign out_final = q | (out_xor & out_and);

endmodule