module turbo_encoder (
    input wire clk,
    input wire reset,
    input wire [1:0] data_in,
    output reg [3:0] encoded_out
);
    reg [1:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            encoded_out <= 4'b0000;
            shift_reg <= 2'b00;
        end else begin
            shift_reg <= data_in;
            encoded_out[3] <= shift_reg[1] ^ shift_reg[0]; // Parity bit for first input
            encoded_out[2] <= shift_reg[0];               // First input bit
            encoded_out[1] <= shift_reg[1];               // Second input bit
            encoded_out[0] <= shift_reg[1] ^ shift_reg[0]; // Parity bit for second input
        end
    end
endmodule