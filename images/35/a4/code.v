module turbo_encoder(
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [5:0] encoded_out
);
    // Internal state variables
    reg [3:0] shift_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 4'b0;
            encoded_out <= 6'b0;
        end else begin
            shift_reg <= {data_in, shift_reg[3:1]};
            // Basic convolutional encoding logic
            encoded_out[5] <= shift_reg[3] ^ shift_reg[2]; // First output bit
            encoded_out[4] <= shift_reg[2] ^ shift_reg[1]; // Second output bit
            encoded_out[3] <= shift_reg[1];                 // Third output bit
            encoded_out[2] <= shift_reg[3] ^ shift_reg[1]; // Fourth output bit
            encoded_out[1] <= shift_reg[2];                 // Fifth output bit
            encoded_out[0] <= shift_reg[0];                 // Sixth output bit
        end
    end
endmodule