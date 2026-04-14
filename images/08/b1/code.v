module barrel_shifter (
    input [1:0] D,
    input S,
    output [1:0] Q
);
    assign Q = (S == 0) ? {D[0], D[1]} : {D[1], D[0]};
endmodule