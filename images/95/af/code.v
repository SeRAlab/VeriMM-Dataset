module top_module(
    input [49:0] a, b,
    input cin,
    output [49:0] s,
    output [49:0] c
);wire [49:0] carry;
    assign s[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));
    
    genvar i;
    generate
        for (i = 1; i < 50; i = i + 1) begin : adder_loop
            assign s[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (carry[i-1] & (a[i] ^ b[i]));
        end
    endgenerate

    assign c = carry;

endmodule