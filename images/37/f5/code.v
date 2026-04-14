module kalman_filter (
    input clk,
    input reset,
    input [15:0] sensor1,
    input [15:0] sensor2,
    input [15:0] covariance1,
    input [15:0] covariance2,
    output reg [15:0] estimated_position,
    output reg [15:0] estimated_covariance
);
    reg [15:0] kalman_gain;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimated_position <= 16'd0;
            estimated_covariance <= 16'd0;
        end else begin
            kalman_gain <= covariance1 / (covariance1 + covariance2);
            estimated_position <= sensor1 + kalman_gain * (sensor2 - sensor1);
            estimated_covariance <= (16'd1 - kalman_gain) * covariance1;
        end
    end
endmodule