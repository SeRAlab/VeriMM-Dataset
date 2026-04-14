module conv_encoder (
    input clk,
    input rst,
    input input_bit,
    output reg [1:0] output_bits
);
    reg [1:0] shift_reg; // 2 bits for the previous input bits

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 2'b00;
            output_bits <= 2'b00;
        end else begin
            // Shift the register
            shift_reg <= {input_bit, shift_reg[1]};
            // Calculate output bits
            output_bits[0] <= shift_reg[0] ^ shift_reg[1] ^ input_bit; // g1 = 101
            output_bits[1] <= shift_reg[0] ^ shift_reg[1] ^ 1'b1; // g2 = 111
        end
    end
endmodule