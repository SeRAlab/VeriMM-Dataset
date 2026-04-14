module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,          // Added the clk input declaration
    output reg [1:0] OUT
);reg [3:0] A_reg, B_reg;
reg [1:0] OUT_reg;

always @ (posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

always @ (posedge clk) begin
    if (A_reg > B_reg) begin
        OUT_reg <= 2'b01;
    end else if (A_reg < B_reg) begin
        OUT_reg <= 2'b10;
    end else begin
        OUT_reg <= 2'b11;
    end
end

assign OUT = OUT_reg;

endmodule