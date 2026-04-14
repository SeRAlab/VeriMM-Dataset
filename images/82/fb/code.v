module top_module(
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    out
);input [1:0] A;
input [2:0] B;
input C;
input D;
input E;
input F;
input G;
input H;
output out;

wire [1:0] temp1;
wire temp2;
wire temp3;

assign temp1 = C ? A : 2'b0;
assign temp2 = D ? (A ^ B) : 1'b0;
assign temp3 = E & F & G & H;

assign out = temp1 | temp2 | temp3;

endmodule