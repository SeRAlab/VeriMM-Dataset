module top_module(
    A,
    B,
    C_in,
    S,
    C_out
);input [3:0] A;
    input [3:0] B;
    input C_in;
    output [3:0] S;
    output C_out;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire [3:0] sum;
    wire carry;

    assign sum = A + B + C_in;
    assign S = sum[3:0];
    assign carry = sum[4];

    assign C_out = carry;

endmodule