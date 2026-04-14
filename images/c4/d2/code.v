module five_input_module (
    input  A1,
    input  A2,
    input  A3,
    input  B1,
    input  B2,
    output Y
);

    // Use an intermediate signal to simplify the logic
    wire intermediate_signal;

    // Implement the logic
    assign intermediate_signal = (A1 & A2) | (A1 & A3) | (B1 & B2);
    assign Y = intermediate_signal;

endmodule