module top_module(
    output Y,
    input A1,
    input A2,
    input A3,
    input A4,
    input EN
);wire [3:0] inputs;
    wire and_output;

    // Assign the inputs to a vector
    assign inputs = {A4, A3, A2, A1};

    // Perform AND operation on inputs and include enable
    assign and_output = (EN) ? (inputs[3] & inputs[2] & inputs[1] & inputs[0]) : 1'b0;

    // Assign the result to Y
    assign Y = and_output;

endmodule