module full_adder_8bit(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
    );

assign {cout, sum} = a + b + cin;

endmodule