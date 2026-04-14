module top_module(
    input A,
    input B,
    input C,
    input D,
    input [1:0] S,
    output Y
);wire w1, w2, w3;

assign w1 = (S == 2'b00) ? A : B;
assign w2 = (S == 2'b00 || S == 2'b01) ? w1 : C;
assign w3 = (S == 2'b00 || S == 2'b01 || S == 2'b10) ? w2 : D;
assign Y = w3;

endmodule