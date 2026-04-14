module merge_sort(
    input [3:0] A,
    input [3:0] B,
    output [7:0] O
);

assign O = { (A[3] < B[3]) ? A[3] : B[3], 
             (A[2] < B[2]) ? A[2] : B[2], 
             (A[1] < B[1]) ? A[1] : B[1], 
             (A[0] < B[0]) ? A[0] : B[0],
             (A[3] < B[3]) ? B[3] : A[3],
             (A[2] < B[2]) ? B[2] : A[2], 
             (A[1] < B[1]) ? B[1] : A[1], 
             (A[0] < B[0]) ? B[0] : A[0] 
            };

endmodule