module top_module(
    input [3:0] a,
    input [3:0] b,
    input sel,
    output reg [3:0] out
);always @(*) begin
        out[0] = a[0] ^ (sel & b[0]);
        out[1] = a[1] ^ (sel & b[1]);
        out[2] = a[2] ^ (sel & b[2]);
        out[3] = a[3] ^ (sel & b[3]);
    end

endmodule