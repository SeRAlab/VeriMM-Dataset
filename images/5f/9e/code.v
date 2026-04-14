module top_module(
    input clk,
    input d,
    input [31:0] in,
    output reg q,
    output reg parity_bit,
    output reg out_final
 );// D flip-flop using T flip-flop
 reg t;
 always @(posedge clk) begin
    t <= d ^ q;
    q <= t;
 end

 // Combinational circuit for parity bit
 wire [31:0] xor_result;
 assign xor_result = ^in;
 assign parity_bit = xor_result;

 // Functional module for final output
 always @(posedge clk) begin
    if (parity_bit == 1'b1) begin
        out_final <= q & 1'b1;
    end else begin
        out_final <= q & 1'b0;
    end
 end

endmodule