module left_shift(input [3:0] A, output [3:0] B);
    assign B = {A[2:0], A[3]};
endmodule