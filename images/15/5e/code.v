module clock_gating(
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);

    wire gated_clk;
    assign gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        q <= d;
    end

endmodule