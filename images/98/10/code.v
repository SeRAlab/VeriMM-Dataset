module top_module( 
    input [2:0] a,
    input [2:0] b,
    input c,
    input control,
    input select,
    output [2:0] out_and_bitwise,
    output out_and_logical,
    output [2:0] out_xor,
    output [5:0] out_not,
    output [3:0] out_mux
);// Binary logic module
    wire [2:0] and_bitwise = a & b;
    wire and_logical = (a != 0) && (b != 0);
    wire [2:0] xor_result = a ^ b;
    assign out_and_bitwise = and_bitwise;
    assign out_and_logical = and_logical;
    assign out_xor = xor_result;

    // Inverse of a and b
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;
    assign out_not = {not_a[2], not_a[1], not_a[0], not_b[2], not_b[1], not_b[0]};

    // Multiplexer
    wire [2:0] mux_input;
    assign mux_input = (select == 0) ? a : ((select == 1) ? b : xor_result);
    assign out_mux = mux_input;

endmodule