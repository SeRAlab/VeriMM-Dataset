module clock_gating(
    input wire clk,
    input wire enable,
    output reg gated_clk
);
    always @(posedge clk) begin
        if (enable)
            gated_clk <= clk;
        else
            gated_clk <= 0;
    end
endmodule