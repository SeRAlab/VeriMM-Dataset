module binary_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);

wire [4:0] C;

assign C = {Cin, 4'b0};

assign S = A + B + C[4:1];

assign Cout = C[5];

endmodule