module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x,
    output reg signed [15:0] y
);
    reg signed [15:0] x1, x2; // Previous inputs
    reg signed [15:0] y1, y2; // Previous outputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
        end else begin
            y <= (x >>> 1) + x1 * (1 << 0) + x2 * 0 + y1 * (-3) + y2 * 2;
            // Update previous values
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule