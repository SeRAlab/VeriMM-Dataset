module clock_gating (
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);
    always @(posedge clk or negedge enable) begin
        if (!enable) begin
            // Hold previous state
            q <= q;
        end else begin
            // Capture input on clock edge
            q <= d;
        end
    end
endmodule