module top_module(
    A,
    B,
    S,
    Sum,
    Difference,
    Cout
);input [3:0] A;
    input [3:0] B;
    input S;
    output [3:0] Sum;
    output [3:0] Difference;
    output Cout;

    wire [4:0] temp_sum;
    wire [4:0] temp_diff;

    assign temp_sum = {1'b0, A} + {1'b0, B};
    assign temp_diff = {1'b0, A} - {S, B};

    assign Sum = temp_sum[3:0];
    assign Difference = temp_diff[3:0];
    assign Cout = temp_sum[4];

endmodule