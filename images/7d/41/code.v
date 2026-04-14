module top_module(
    input [3:0] IN,
    input [1:0] SEL,
    input EN,
    input clk,          // Added clock signal input
    output reg out
);reg [3:0] reg_IN;
reg [1:0] reg_SEL;
reg reg_EN;

always @(posedge clk) begin
    reg_IN <= IN;
    reg_SEL <= SEL;
    reg_EN <= EN;
end

always @(posedge clk) begin
    if (reg_EN) begin
        case (reg_SEL)
            2'b00: out <= reg_IN[0];
            2'b01: out <= reg_IN[1];
            2'b10: out <= reg_IN[2];
            2'b11: out <= reg_IN[3];
        endcase
    end else begin
        out <= 1'bz;
    end
end

endmodule