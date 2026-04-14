module clock_gating (
    input wire clk,          // Clock input
    input wire enable,       // Clock enable signal
    input wire d,           // Data input
    output reg q           // Data output
);
    reg gated_clk;

    always @(posedge clk) begin
        if (enable) begin
            gated_clk <= clk;
            q <= d;
        end
    end
endmodule