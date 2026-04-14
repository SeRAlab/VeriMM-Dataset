module full_adder_1bit(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
    );

assign {cout, sum} = a + b + cin;

endmodule