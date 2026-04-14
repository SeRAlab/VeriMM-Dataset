module top_module(
    input CLK,
    input EN,
    input TE,
    input [63:0] D,
    output reg [63:0] Q
);wire gated_clk = (EN & TE) ? CLK : 1'b0;

    always @(posedge gated_clk) begin
        if (EN) begin
            Q <= D;
        end
    end

endmodule