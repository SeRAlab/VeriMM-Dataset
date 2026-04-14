module top_module(
    A,
    B,
    X
);input [7:0] A;
    input [7:0] B;
    output [7:0] X;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire [7:0] temp;

    // Calculate XOR of each bit
    assign temp[0] = (~A[0] & B[0]) | (A[0] & ~B[0]);
    assign temp[1] = (~A[1] & B[1]) | (A[1] & ~B[1]);
    assign temp[2] = (~A[2] & B[2]) | (A[2] & ~B[2]);
    assign temp[3] = (~A[3] & B[3]) | (A[3] & ~B[3]);
    assign temp[4] = (~A[4] & B[4]) | (A[4] & ~B[4]);
    assign temp[5] = (~A[5] & B[5]) | (A[5] & ~B[5]);
    assign temp[6] = (~A[6] & B[6]) | (A[6] & ~B[6]);
    assign temp[7] = (~A[7] & B[7]) | (A[7] & ~B[7]);

    // Assign result to output
    assign X = temp;

endmodule