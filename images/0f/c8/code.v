module clock_gating (
    input wire clk,
    input wire enable,
    input wire reset,
    input wire d,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else if (enable) begin
            q <= d;
        end
    end
endmodule