module clock_gating(
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);
    wire gated_clk;

    assign gated_clk = clk & enable; // Clock gating logic

    always @(posedge gated_clk) begin
        q <= d; // Capture data on the rising edge of the gated clock
    end
endmodule