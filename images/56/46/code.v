module top_module(
    input clk,
    input a,
    input b,
    output out
);reg a_reg, b_reg;
wire nand1_out, nand2_out, nand3_out;

// Pipeline stage 1
assign nand1_out = ~(a_reg & b_reg);
always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
end

// Pipeline stage 2
assign nand2_out = ~(a_reg & nand1_out);
always @(posedge clk) begin
    // No need to assign a_reg again, just keep it here for the clock edge
    // a_reg <= a_reg; // This is redundant
end

// Pipeline stage 3
assign nand3_out = ~(b_reg & nand2_out);
always @(posedge clk) begin
    // No need to assign b_reg again, just keep it here for the clock edge
    // b_reg <= b_reg; // This is redundant
end

// Output stage
assign out = nand3_out;

endmodule