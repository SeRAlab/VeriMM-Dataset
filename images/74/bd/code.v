module top_module(input [26:0] A, input [26:0] B, output [53:0] Y);parameter A_SIGNED = 1;
parameter B_SIGNED = 1;


specify
    (A *> Y) = 3732;
    (B *> Y) = 3928;
endspecify

wire [53:0] A_, B_;

if (A_SIGNED)
    assign A_ = $signed(A);
else
    assign A_ = $unsigned(A);

if (B_SIGNED)
    assign B_ = $signed(B);
else
    assign B_ = $unsigned(B);

assign Y = A_ * B_;

endmodule