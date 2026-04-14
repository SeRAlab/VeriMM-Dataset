module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] sel,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] temp;
    wire [3:0] temp2;

    assign temp = A ^ B;
    assign temp2 = A & B;

    assign Cout = ((temp & Cin) | (temp2 & Cin) | (temp2 & temp));

    assign S = ((sel == 2'b00) ? (A ^ B ^ Cin) : ((sel == 2'b01) ? (A ^ (~B) ^ Cin) : (A & B)));

endmodule