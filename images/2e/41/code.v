module turbo_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [1:0] encoded_out
);
    reg [1:0] state;
    reg [2:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            shift_reg <= 0;
            encoded_out <= 0;
        end else begin
            shift_reg <= {shift_reg[1:0], data_in}; // Shift in the new data
            // Simple encoding logic for two convolutional codes
            encoded_out[0] <= shift_reg[0] ^ shift_reg[1]; // Example: XOR for first bit
            encoded_out[1] <= shift_reg[1] ^ shift_reg[2]; // Example: XOR for second bit
        end
    end
endmodule