module top_module(
    input [15:0] a,
    input [15:0] b,
    input [3:0] shift,
    input select,
    output [15:0] out
);// 16-bit adder
    wire [15:0] adder_out;
    assign adder_out = a + b;

    // 4-bit shifter
    wire [15:0] shifter_out;
    assign shifter_out = (shift == 0) ? adder_out :
                         (shift < 16) ? (adder_out >> shift) : 16'b0;

    // Functional module for bitwise OR
    wire [15:0] or_out;
    assign or_out = adder_out | shifter_out;

    // Output selection
    assign out = (select == 1) ? (shifter_out | or_out) : (adder_out | or_out);

endmodule