module clock_divider(
    input clk,
    input rst,
    output reg clk_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_out <= 0;
        end else begin
            clk_out <= ~clk_out;
        end
    end
endmodule