module conv_encoder(
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg data_out1,
    output reg data_out2
);
    reg [1:0] shift_reg; // 2-bit shift register to hold the previous inputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 2'b00;
            data_out1 <= 1'b0;
            data_out2 <= 1'b0;
        end else begin
            // Shift the register
            shift_reg <= {data_in, shift_reg[1]};
            // Generate output bits based on the current and previous input bits
            data_out1 <= shift_reg[0] ^ shift_reg[1] ^ data_in; // Example logic for output 1
            data_out2 <= shift_reg[0] ^ data_in; // Example logic for output 2
        end
    end
endmodule