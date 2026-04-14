module turbo_encoder (
    input clk,
    input rst,
    input bit_in,
    output reg [1:0] encoded_out
);
    reg [2:0] shift_reg1, shift_reg2; // Shift registers for two encoders
    wire [1:0] encoder1_out, encoder2_out;

    // First convolutional encoder polynomial: g1 = [1, 1, 1], g2 = [1, 0, 1]
    assign encoder1_out[0] = shift_reg1[0] ^ shift_reg1[1] ^ shift_reg1[2]; // g1
    assign encoder1_out[1] = shift_reg1[0] ^ shift_reg1[2]; // g2

    // Second convolutional encoder polynomial: g1 = [1, 1, 0], g2 = [1, 1, 1]
    assign encoder2_out[0] = shift_reg2[0] ^ shift_reg2[1]; // g1
    assign encoder2_out[1] = shift_reg2[0] ^ shift_reg2[1] ^ shift_reg2[2]; // g2

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg1 <= 3'b0;
            shift_reg2 <= 3'b0;
            encoded_out <= 2'b0;
        end else begin
            shift_reg1 <= {bit_in, shift_reg1[2:1]};
            shift_reg2 <= {bit_in, shift_reg2[2:1]};
            encoded_out <= encoder1_out ^ encoder2_out; // XOR outputs from both encoders
        end
    end
endmodule