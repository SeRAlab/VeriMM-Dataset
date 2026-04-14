module top_module(
    input [31:0] x,
    output [31:0] y
);wire [1:0] first_two_bits;
    wire [12:0] last_thirteen_bits;
    wire [21:0] last_twentytwo_bits;

    // Take the first two bits of x and put them at the end of y
    assign first_two_bits = x[1:0];
    assign y[31:2] = x[31:2];
    assign y[1:0] = first_two_bits;

    // Take the last 13 bits of x and put them at the beginning of y
    assign last_thirteen_bits = x[12:0];
    assign y[12:0] = last_thirteen_bits;

    // Take the last 22 bits of x and invert every bit, then put them at the beginning of y
    assign last_twentytwo_bits = ~x[31:10];
    assign y[31:22] = last_twentytwo_bits;

endmodule