module turbo_encoder (
    input wire clk,
    input wire reset,
    input wire [0:0] input_bit,
    output reg [1:0] encoded_out
);

reg [1:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 2'b00;
        encoded_out <= 2'b00;
    end else begin
        shift_reg <= {shift_reg[0], input_bit}; // Shift in the new input bit
        encoded_out <= {shift_reg[1] ^ input_bit, shift_reg[0]}; // Simple convolutional encoding
    end
end

endmodule