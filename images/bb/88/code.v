module top_module(clk, A, B, C, G);input clk;
    input A, B, C;
    output G;

    reg G_reg;

    always @(posedge clk) begin
        G_reg <= A & B & C;
    end

    assign G = G_reg;
endmodule