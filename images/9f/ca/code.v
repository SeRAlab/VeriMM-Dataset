module top_module(
    input [3:0] A,
    input [1:0] S,
    output [3:0] Y
);assign Y = (S == 2'b00) ? A :
               (S == 2'b01) ? {A[2:0], 1'b0} :
               (S == 2'b10) ? {1'b0, A[3:1]} :
                              A[1:0];

endmodule