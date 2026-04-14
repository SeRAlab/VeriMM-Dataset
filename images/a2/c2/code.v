module top_module(
    input clk,
    input a,
    input b,
    input c,
    input sel,
    output reg out
);reg xor1, xor2, xor3;

always @(posedge clk) begin
    xor1 <= a ^ b;
    xor2 <= b ^ c;
    xor3 <= c ^ a;
    
    case(sel)
        1'b0: out <= xor1 & xor2 | xor1 & xor3 | xor2 & xor3;
        1'b1: out <= xor1;
    endcase
end

endmodule