module full_adder(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
    );

wire axorb;
wire aandb;
wire axorb_and_cin;

xor (axorb, a, b);
xor (sum, axorb, cin);
and (aandb, a, b);
and (axorb_and_cin, axorb, cin);
or (cout, aandb, axorb_and_cin);

endmodule