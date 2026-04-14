module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum,
    output [99:0] final_output
);wire [99:0] c;
    wire [99:0] p;
    wire [99:0] g;

    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];

    generate
        genvar i;
        for (i = 1; i < 100; i = i + 1) begin : carry_generation
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    assign cout = c[99];
    assign sum = a + b + cin;
    assign final_output = sum + (cout << 1);

endmodule