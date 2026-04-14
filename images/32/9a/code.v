module monte_carlo_pi(
    input [3:0] num_points,
    input [3:0] points_inside_circle,
    output reg [7:0] pi_estimate
);
    always @(*) begin
        if (num_points == 0) begin
            pi_estimate = 8'd0; // Avoid division by zero
        end else begin
            pi_estimate = (points_inside_circle * 8'd4) / num_points;
        end
    end
endmodule