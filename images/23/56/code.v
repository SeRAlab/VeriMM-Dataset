module ofdm_symbol_generator (
    input clk,
    input [3:0] data_in,
    output reg [7:0] symbol_out
);

always @(posedge clk) begin
    case(data_in)
        4'b0000: symbol_out <= 8'b00000000;
        4'b0001: symbol_out <= 8'b00000001;
        4'b0010: symbol_out <= 8'b00000010;
        4'b0011: symbol_out <= 8'b00000011;
        4'b0100: symbol_out <= 8'b00000100;
        4'b0101: symbol_out <= 8'b00000101;
        4'b0110: symbol_out <= 8'b00000110;
        4'b0111: symbol_out <= 8'b00000111;
        4'b1000: symbol_out <= 8'b00001000;
        4'b1001: symbol_out <= 8'b00001001;
        4'b1010: symbol_out <= 8'b00001010;
        4'b1011: symbol_out <= 8'b00001011;
        4'b1100: symbol_out <= 8'b00001100;
        4'b1101: symbol_out <= 8'b00001101;
        4'b1110: symbol_out <= 8'b00001110;
        4'b1111: symbol_out <= 8'b00001111;
        default: symbol_out <= 8'b00000000; // Default case
    endcase
end

endmodule