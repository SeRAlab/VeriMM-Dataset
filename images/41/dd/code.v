module top_module(
    input [1:0] in0,
    input [1:0] in1,
    input [1:0] in2,
    input [1:0] sel,
    output [1:0] out
);

    // Assign the output based on the select signal
    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 : in2;

endmodule