module top_module(
    Y,
    A,
    B,
    C
);output Y;
    input  A;
    input  B;
    input  C;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire AB;
    assign AB = A & B; // perform bitwise AND operation on A and B

    wire prod;
    assign prod = AB | C; // perform bitwise OR operation on AB and C

    assign Y = prod; // assign the result to the output signal Y

endmodule