module top_module(
    input wire clk,
    input wire reset,
    output reg clk_div
);

    always @(posedge clk) begin
        if (reset) begin
            clk_div <= 1'b0;
        end else begin
            clk_div <= ~clk_div;
        end
    end

endmodule