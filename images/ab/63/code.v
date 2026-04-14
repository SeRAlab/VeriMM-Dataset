module top_module(
    a,
    b,
    cin,
    sum,
    cout
);input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;

    wire [3:0] temp_sum;
    wire [4:0] temp_cout;

    assign temp_sum = a + b + cin;
    assign temp_cout = {1'b0, temp_sum} + {1'b0, ~a, 1'b1} + {1'b0, ~b, 1'b1} + {1'b0, ~cin, 1'b1};

    assign sum = temp_sum;
    assign cout = temp_cout[4];

endmodule