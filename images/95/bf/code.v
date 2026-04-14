module top_module(
    input [3:0] A,
    input [3:0] B,
    input shift,
    input clk,          // Added clk input
    output [3:0] result
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg shift_reg;
reg [3:0] result_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    shift_reg <= shift;
end

always @(posedge clk) begin
    if (shift_reg == 1'b0) begin
        result_reg <= A_reg;
    end else begin
        result_reg <= A_reg << B_reg; // Logical left shift
    end
end

assign result = result_reg;

endmodule