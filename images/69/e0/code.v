module adder_4bit(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout);
    
    wire [3:0] c_out;

    full_adder FA0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c_out[0]));
    full_adder FA1 (.a(a[1]), .b(b[1]), .cin(c_out[0]), .sum(sum[1]), .cout(c_out[1]));
    full_adder FA2 (.a(a[2]), .b(b[2]), .cin(c_out[1]), .sum(sum[2]), .cout(c_out[2]));
    full_adder FA3 (.a(a[3]), .b(b[3]), .cin(c_out[2]), .sum(sum[3]), .cout(c_out[3]));

    assign cout = c_out[3];
endmodule

module full_adder (input a, b, cin, output sum, cout);
    assign {cout, sum} = a + b + cin;
endmodule