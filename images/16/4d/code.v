module frequency_divider (
    input clk,
    input reset,
    output reg clk_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
        end else begin
            clk_out <= ~clk_out;
        end
    end
endmodule