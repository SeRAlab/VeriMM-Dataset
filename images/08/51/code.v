module SLAM(
    input wire clk,
    input wire reset,
    input wire [15:0] odometry_x,
    input wire [15:0] odometry_y,
    input wire [15:0] landmark_x,
    input wire [15:0] landmark_y,
    output reg [15:0] estimated_x,
    output reg [15:0] estimated_y
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimated_x <= 16'b0;
            estimated_y <= 16'b0;
        end else begin
            // Simple update rule for localization
            estimated_x <= odometry_x + (landmark_x >> 1); // Simplified estimation
            estimated_y <= odometry_y + (landmark_y >> 1); // Simplified estimation
        end
    end
endmodule