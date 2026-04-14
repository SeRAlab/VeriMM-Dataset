module gated_d_flip_flop (
    input clk,
    input en,
    input D,
    output reg Q
);
    wire gated_clk;

    // Clock gating logic
    assign gated_clk = clk & en;

    always @(posedge gated_clk) begin
        Q <= D;
    end

endmodule