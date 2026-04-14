module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    input clk,          // Add clk input to the module
    output eq,
    output lt,
    output gt
);reg signed [3:0] A_reg, B_reg;
reg eq_reg, lt_reg, gt_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

always @(posedge clk) begin
    if (A_reg == B_reg) begin
        eq_reg <= 1'b1;
        lt_reg <= 1'b0;
        gt_reg <= 1'b0;
    end else if (A_reg < B_reg) begin
        eq_reg <= 1'b0;
        lt_reg <= 1'b1;
        gt_reg <= 1'b0;
    end else begin
        eq_reg <= 1'b0;
        lt_reg <= 1'b0;
        gt_reg <= 1'b1;
    end
end

assign eq = eq_reg;
assign lt = lt_reg;
assign gt = gt_reg;

endmodule