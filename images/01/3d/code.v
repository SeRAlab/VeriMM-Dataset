module clock_gated_ff (
    input wire D,
    input wire clk,
    input wire en,
    output reg Q
);
    wire gated_clk;

    // Clock gating logic
    assign gated_clk = clk & en;

    always @(posedge gated_clk) begin
        Q <= D;
    end
endmodule