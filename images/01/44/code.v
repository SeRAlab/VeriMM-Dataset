module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] shift_reg; // 2-bit shift register for memory

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 2'b00; // Reset shift register
            data_out <= 2'b00; // Reset output
        end else begin
            shift_reg <= {data_in, shift_reg[1]}; // Shift in the new data
            // Convolutional encoding based on (7, 5): 
            data_out[0] <= shift_reg[0] ^ shift_reg[1] ^ data_in; // First output bit
            data_out[1] <= shift_reg[0] ^ data_in; // Second output bit
        end
    end
endmodule