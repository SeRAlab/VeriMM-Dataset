module clock_gating(
    input clk,
    input clk_en,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (clk_en) begin
            q <= d;
        end
    end
endmodule