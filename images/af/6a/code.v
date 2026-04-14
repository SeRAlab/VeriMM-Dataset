module top_module(
    input       clk1,
    input       clk2,
    input       rst_n1,
    input       rst_n2,
    input       en1,
    input       en2,
    output      clk1_g,
    output      clk2_g,
    output reg  rst_n_reg1,
    output reg  rst_n_reg2,
    output      clk1_div
);reg clk1_div_reg;


assign clk1_g = clk1 & en1;
assign clk2_g = clk2 & en2;

assign rst_n_reg1 = rst_n1;
assign rst_n_reg2 = rst_n2;

always @(posedge clk1 or negedge rst_n1) begin
    if (~rst_n1) clk1_div_reg <= 1'b0;
    else clk1_div_reg <= ~clk1_div_reg;
end














assign clk1_div = clk1_div_reg;

endmodule