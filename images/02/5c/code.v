module pll_4x (
    input clk_in,
    input reset,
    output reg clk_out
);
    reg [1:0] divider;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            divider <= 2'b00;
            clk_out <= 0;
        end else begin
            divider <= divider + 1;
            if (divider == 2'b11) begin
                clk_out <= ~clk_out;
            end
        end
    end
endmodule