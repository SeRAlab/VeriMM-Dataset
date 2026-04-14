module barrel_shifter (
    input [15:0] A,
    input [15:0] B,
    input [3:0] shift,
    output [15:0] out
);

    assign out = (shift == 0) ? B :
                (shift[3] == 1) ? (shift[2:0] == 0 ? A : {A[shift[2:0]-1:0], 0}) :
                (A[15] == 0 ? {A[15:shift[2]], A[shift[2]-1:0]} : {16'd0, A[15:shift[2]]});

endmodule