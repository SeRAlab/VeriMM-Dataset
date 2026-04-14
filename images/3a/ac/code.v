module clock_gating (
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);
    reg gated_clk;

    always @(*) begin
        gated_clk = clk & enable; // Clock gating logic
    end

    always @(posedge gated_clk) begin
        q <= d; // D flip-flop behavior
    end
endmodule