module convolutional_encoder (
    input clk,
    input reset,
    input input_bit,
    output reg [1:0] output_bits
);
    reg [2:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 3'b000;
            output_bits <= 2'b00;
        end else begin
            shift_reg <= {input_bit, shift_reg[2:1]};
            output_bits[0] <= shift_reg[2] ^ shift_reg[1] ^ shift_reg[0]; // g1 = 111
            output_bits[1] <= shift_reg[2] ^ shift_reg[0]; // g2 = 101
        end
    end
endmodule