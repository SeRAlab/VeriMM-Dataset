module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement,
    output reg [15:0] estimate
);
    reg [15:0] prev_estimate;
    parameter K = 16'h0040; // Gain

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimate <= 16'h0000;
            prev_estimate <= 16'h0000;
        end else begin
            estimate <= prev_estimate + (K * (measurement - prev_estimate)) >> 8; // Update estimate
            prev_estimate <= estimate; // Store previous estimate
        end
    end
endmodule