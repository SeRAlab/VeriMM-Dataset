module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output [7:0] LEDS
);wire signed [7:0] mult_result;
    wire [2:0] decoder_out;
    wire signed [7:0] sum_result;

    // Define the multiplier for signed 4-bit numbers
    assign mult_result = A * B;

    // Decoder for the multiplication result (assuming a simple binary to 3-bit decoder)
    assign decoder_out = (mult_result[7:5] == 3'b000) ? 3'b000 :
                         (mult_result[7:5] == 3'b001) ? 3'b001 :
                         (mult_result[7:5] == 3'b010) ? 3'b010 :
                         (mult_result[7:5] == 3'b011) ? 3'b011 :
                         (mult_result[7:5] == 3'b100) ? 3'b100 :
                         (mult_result[7:5] == 3'b101) ? 3'b101 :
                         (mult_result[7:5] == 3'b110) ? 3'b110 :
                         3'b111; // Assuming a 3-bit output based on higher bits of mult_result

    assign LEDS = ~{decoder_out, 3'b000};

    assign sum_result = mult_result + {5'b00000, decoder_out}; // Adjusted to match size

endmodule