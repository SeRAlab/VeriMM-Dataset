module gated_dff (
    input wire clk,
    input wire en,
    input wire d,
    output reg q
);
    wire gated_clk;

    // Clock gating logic
    assign gated_clk = clk & en;

    always @(posedge gated_clk) begin
        q <= d;
    end
endmodule