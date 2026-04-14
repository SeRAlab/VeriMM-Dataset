module convolutional_encoder(
    input clk,
    input reset,
    input bit_in,
    output reg [1:0] bit_out
);
    reg [1:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 2'b00;
            bit_out <= 2'b00;
        end else begin
            shift_reg <= {bit_in, shift_reg[1]};
            bit_out <= {shift_reg[1] ^ bit_in, shift_reg[0] ^ bit_in};
        end
    end
endmodule