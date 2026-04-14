module clock_gated_dff (
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);
    wire gated_clk;

    // Clock gating logic
    assign gated_clk = clk & enable;

    // D Flip-Flop with gated clock
    always @(posedge gated_clk) begin
        q <= d;
    end
endmodule