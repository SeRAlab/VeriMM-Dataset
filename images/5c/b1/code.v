module top_module(sum, cout, a, b, cin);output [3:0] sum;
    output cout;
    input [3:0] a;
    input [3:0] b;
    input cin;

    wire [3:0] temp_sum;
    wire [4:0] temp_carry;

    // Full Adder
    assign temp_carry[0] = cin;
    assign {temp_carry[1], temp_sum[0]} = a[0] + b[0] + temp_carry[0];
    assign {temp_carry[2], temp_sum[1]} = a[1] + b[1] + temp_carry[1];
    assign {temp_carry[3], temp_sum[2]} = a[2] + b[2] + temp_carry[2];
    assign {temp_carry[4], temp_sum[3]} = a[3] + b[3] + temp_carry[3];

    assign sum = temp_sum;
    assign cout = temp_carry[4];
endmodule