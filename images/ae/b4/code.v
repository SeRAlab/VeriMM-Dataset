module top_module(
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [1:0] sel,
    output [15:0] out_not,
    output [7:0] out_and_bitwise,
    output [7:0] out_xor_bitwise,
    output [7:0] out_nor_bitwise
);// 4-to-1 Multiplexer
    wire [7:0] mux_out;
    assign mux_out = (sel == 2'b00) ? in0 :
                     (sel == 2'b01) ? in1 :
                     (sel == 2'b10) ? in2 :
                                      in3;

    // Bitwise Operations
    wire [7:0] and_out;
    wire [7:0] xor_out;
    wire [7:0] nor_out;
    assign and_out = in0 & in1;
    assign xor_out = in2 ^ in3;
    assign nor_out = ~(in0 | in1);

    // NOT Inverse
    wire [7:0] inv1;
    wire [7:0] inv2;
    assign inv1 = ~mux_out;
    assign inv2 = ~{in3, in2};

    // Output
    assign out_not = {inv2, inv1};
    assign out_and_bitwise = and_out;
    assign out_xor_bitwise = xor_out;
    assign out_nor_bitwise = nor_out;

endmodule