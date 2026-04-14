module top_module(
    input clk,
    input [2:0] A,
    output reg [7:0] Y
);reg [7:0] Y_reg;

always @ (posedge clk) begin
    case (A)
        3'b000: Y_reg <= 8'b00000001; // Set only Y[0]
        3'b001: Y_reg <= 8'b00000010; // Set only Y[1]
        3'b010: Y_reg <= 8'b00000100; // Set only Y[2]
        3'b011: Y_reg <= 8'b00001000; // Set only Y[3]
        3'b100: Y_reg <= 8'b00010000; // Set only Y[4]
        3'b101: Y_reg <= 8'b00100000; // Set only Y[5]
        3'b110: Y_reg <= 8'b01000000; // Set only Y[6]
        3'b111: Y_reg <= 8'b10000000; // Set only Y[7]
        default: Y_reg <= 8'b00000000; // Default case
    endcase
end

assign Y = Y_reg;

endmodule