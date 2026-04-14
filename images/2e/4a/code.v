module kalman_filter(
    input wire [15:0] z1,
    input wire [15:0] r1,
    input wire [15:0] z2,
    input wire [15:0] r2,
    output reg [15:0] z_fused,
    output reg [15:0] r_fused,
    input wire clk,
    input wire rst
);

    reg [15:0] K;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_fused <= 16'b0;
            r_fused <= 16'b0;
        end else begin
            K <= r1 / (r1 + r2);
            z_fused <= z1 + K * (z2 - z1);
            r_fused <= (16'b1111111111111111 - K) * r1; // Scaling to maintain size
        end
    end
endmodule