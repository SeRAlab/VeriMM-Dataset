module adder4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] s,
    output cout);

    assign {cout, s} = a + b + cin;
endmodule