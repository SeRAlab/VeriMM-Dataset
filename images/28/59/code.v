module kalman_filter (
    input clk,
    input rst,
    input [31:0] z,  // measurement input
    input [31:0] u,  // control input
    input [31:0] K,  // Kalman gain
    output reg [31:0] x  // estimated state output
);
    reg [31:0] x_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 32'b0;
            x_prev <= 32'b0;
        end else begin
            // Predict
            x_prev <= x + u;
            // Update
            x <= x_prev + (K * (z - x_prev));
        end
    end
endmodule