module clock_gated_ff (
    input wire clk,
    input wire clk_enable,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (clk_enable) begin
            q <= d;
        end
    end
endmodule