module xnor_5bit (
    input [4:0] A,
    input [4:0] B,
    output [4:0] Y
);
    assign Y = ~(A ^ B); // XNOR operation
endmodule