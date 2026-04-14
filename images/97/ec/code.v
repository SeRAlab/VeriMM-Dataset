module top_module(
    input [1:0] SEL,
    input clk,        // Added the clk input port
    output reg [15:0] OUT
);reg [15:0] OUT_reg;

always @(*) begin
    case (SEL)
        2'b00: OUT_reg = 16'b0000000000000001;
        2'b01: OUT_reg = 16'b0000000000000010;
        2'b10: OUT_reg = 16'b0000000000000100;
        2'b11: OUT_reg = 16'b0000000000001000;
        default: OUT_reg = 16'b0000000000000000;
    endcase
end

always @(posedge clk) begin
    OUT <= OUT_reg;
end

endmodule