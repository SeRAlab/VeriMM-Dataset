module full_adder_4bit(a, b, cin, sum, cout);
    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] sum;
    output cout;

    wire [3:0] carry;

    assign {cout, sum} = a + b + cin;
endmodule