module kalman_filter (
    input clk,
    input rst,
    input [15:0] z,
    input [15:0] x_prev,
    input [15:0] Q,
    input [15:0] R,
    output reg [15:0] x_est,
    output reg [15:0] P
);
    reg [15:0] K;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_est <= 16'b0;
            P <= 16'b0;
        end else begin
            K <= P / (P + R);
            x_est <= x_prev + K * (z - x_prev);
            P <= (16'hFFFF - K) * P + Q; // (1 - K) is approximated as (16'hFFFF - K)
        end
    end
endmodule