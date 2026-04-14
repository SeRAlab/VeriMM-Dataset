module top_module(
    input clk,                // Added clock input
    input [7:0] in,
    output reg [2:0] out
);reg [7:0] in_reg;
reg [2:0] out_reg;

always @(posedge clk) begin
    in_reg <= in;
end

always @(posedge clk) begin
    casez(in_reg)
        8'b00000001: out_reg <= 3'b000;
        8'b00000010: out_reg <= 3'b001;
        8'b00000100: out_reg <= 3'b010;
        8'b00001000: out_reg <= 3'b011;
        8'b00010000: out_reg <= 3'b100;
        8'b00100000: out_reg <= 3'b101;
        8'b01000000: out_reg <= 3'b110;
        8'b10000000: out_reg <= 3'b111;
        default: out_reg <= 3'bxxx; // Set default for unknown input
    endcase
end

always @(posedge clk) begin
    out <= out_reg;
end

endmodule