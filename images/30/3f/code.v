module pll (
    input wire clk_ref,
    input wire reset,
    output reg clk_out
);
    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
        end else begin
            clk_out <= ~clk_out; // Toggle output clock
        end
    end
endmodule