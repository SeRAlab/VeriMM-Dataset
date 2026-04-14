module adder (
    input [3:0] in1,
    input [3:0] in2,
    output [4:0] out1
);

    // Adder logic
    assign out1 = in1 + in2;

endmodule