module top_module(
    input clk,                     // Added clk input
    input [7:0] A,
    input [7:0] B,
    input carry_in,
    input sub,
    output reg [7:0] sum,
    output reg borrow_out
);reg [7:0] A_reg, B_reg, sum_reg;
reg carry_reg, borrow_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    carry_reg <= carry_in;      // Moved this here to update carry_in at every clock cycle
end

always @(posedge clk) begin
    if (sub) begin
        {borrow_reg, sum_reg} <= A_reg - B_reg - carry_reg;  // Use full-width for borrow flag
    end else begin
        {carry_reg, sum_reg} <= A_reg + B_reg + carry_reg;    // Use full-width for carry flag
    end
end

assign sum = sum_reg;
assign borrow_out = borrow_reg;

endmodule