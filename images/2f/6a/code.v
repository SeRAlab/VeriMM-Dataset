module clock_gating(
    input wire clk,
    input wire enable,
    output reg gated_clk
);
    always @(posedge clk) begin
        if (enable) begin
            gated_clk <= 1'b1;
        end else begin
            gated_clk <= 1'b0;
        end
    end
endmodule