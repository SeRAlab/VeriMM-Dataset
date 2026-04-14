module clock_gating(
    input wire clk,
    input wire enable,
    output reg gated_clk
);
    always @(posedge clk) begin
        if (enable) begin
            gated_clk <= ~gated_clk; // Toggle gated clock when enabled
        end else begin
            gated_clk <= 1'b0; // Keep gated clock low when disabled
        end
    end
endmodule