module top_module(
    input clk,            // Add clk input to the module
    input [3:0] a,
    input [3:0] b,
    input enable,
    output reg [7:0] prod
);reg [3:0] a_reg;
reg [3:0] b_reg;
reg [7:0] prod_reg;

always @(posedge clk) begin
    if (enable) begin
        prod_reg <= a_reg * b_reg;
    end else begin
        prod_reg <= 8'b0;
    end
end

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
end

assign prod = prod_reg;

endmodule