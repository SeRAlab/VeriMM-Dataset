module top_module(A, B, Sum, Cout);input [7:0] A, B;
    output [8:0] Sum;
    output Cout;

    wire [7:0] temp_sum;
    wire carry;

    assign temp_sum = A + B;
    assign Sum = {1'b0, temp_sum};

    assign carry = (A[7] & B[7]) | (A[7] & ~temp_sum[7]) | (B[7] & ~temp_sum[7]);
    assign Cout = carry;

endmodule