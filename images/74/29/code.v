module top_module(
    input a, b,                     // Two input bits for the half adder
    input [3:0] mux_inputs,         // Four inputs for the 4-to-1 multiplexer
    input [1:0] select,             // Two select bits for the 4-to-1 multiplexer
    output [3:0] result             // 4-bit output from the functional module
);// Half adder
    wire sum = a ^ b;
    wire carry_out = a & b;

    // 4-to-1 multiplexer
    wire [1:0] select_1 = select;
    wire [1:0] select_2 = select;
    wire c = mux_inputs[0];
    wire d = mux_inputs[1];
    wire [1:0] mux_output = {c, d};
    wire [1:0] mux_select = {select_1[0], select_2[0]};
    wire [1:0] mux_output_2 = {mux_inputs[2], mux_inputs[3]};
    wire [3:0] final_output;

    // Functional module
    assign final_output = (result == 1) ? mux_output : {sum, carry_out};

    // Assigning the final output to the module output
    assign result = final_output;

endmodule