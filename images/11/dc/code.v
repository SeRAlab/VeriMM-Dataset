module pll_2x (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);

    reg [1:0] clk_div;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            clk_div <= 2'b00;
            clk_out <= 1'b0;
        end else begin
            clk_div <= clk_div + 1;
            if (clk_div == 2'b01) begin
                clk_out <= ~clk_out;
            end
        end
    end
endmodule