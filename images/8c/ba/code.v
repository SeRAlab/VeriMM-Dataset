module top_module(
    input wire [7:0] in_hi,
    input wire [7:0] in_lo,
    output wire [15:0] final_output
);wire [15:0] concat_output;
    wire [7:0] xor_output;

    // Concatenation operation: combining in_hi and in_lo
    assign concat_output = {in_hi, in_lo};

    // XOR operation
    assign xor_output = in_hi ^ in_lo;

    // Final output calculation
    assign final_output = (xor_output * concat_output) + concat_output;

endmodule