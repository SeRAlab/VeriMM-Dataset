module top_module(
    input clk,          // Added clock input
    input [2:0] in,
    output reg [7:0] out
);reg [7:0] out_reg;
reg [2:0] in_reg;

always @(posedge clk) begin
    in_reg <= in;
end

always @(posedge clk) begin
    case(in_reg)
        3'b000: out_reg <= 8'b11111110;
        3'b001: out_reg <= 8'b11111101;
        3'b010: out_reg <= 8'b11111011;
        3'b011: out_reg <= 8'b11110111;
        3'b100: out_reg <= 8'b11101111;
        3'b101: out_reg <= 8'b11011111;
        3'b110: out_reg <= 8'b10111111;
        3'b111: out_reg <= 8'b01111111;
        default: out_reg <= 8'b11111111;
    endcase
end

always @(posedge clk) begin
    out <= out_reg;
end

endmodule