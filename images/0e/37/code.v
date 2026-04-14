module convolutional_encoder (
    input clk,
    input reset,
    input bit_in,
    output reg [1:0] bit_out
);
    reg [2:0] state; // 3-bit shift register for the encoder

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            bit_out <= 2'b00;
        end else begin
            state <= {state[1:0], bit_in}; // Shift in the new bit
            // Calculate the output bits based on the generator polynomials
            bit_out[0] <= state[2] ^ state[1] ^ bit_in; // g1 = 7 (111)
            bit_out[1] <= state[1] ^ state[0] ^ bit_in; // g2 = 5 (101)
        end
    end
endmodule