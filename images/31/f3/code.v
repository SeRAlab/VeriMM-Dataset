module clock_gating_ff (
    input wire clk,
    input wire en,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (en) begin
            q <= d;
        end
        // else: do nothing, hold the previous state
    end
endmodule