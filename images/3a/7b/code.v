module clock_gating(
    input clk,
    input enable,
    input d,
    output reg q
);
    always @(posedge clk or negedge enable) begin
        if (!enable) begin
            // Hold state if enable is low
            q <= q;
        end else begin
            // Update state on rising edge of clock if enable is high
            q <= d;
        end
    end
endmodule