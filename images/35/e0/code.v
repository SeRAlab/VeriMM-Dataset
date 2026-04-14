module monte_carlo_pi(
    input [7:0] x, // x-coordinate (0 to 255)
    input [7:0] y, // y-coordinate (0 to 255)
    input [7:0] total_points, // total number of points
    output reg [31:0] pi_estimate // estimated value of π
);
    wire inside_circle;
    assign inside_circle = (x * x + y * y) <= (255 * 255); // Check if inside unit circle

    always @(*) begin
        if (total_points > 0) begin
            pi_estimate = (inside_circle ? 1 : 0) * 4 / total_points; // Estimate π
        end else begin
            pi_estimate = 0; // Handle zero total points case
        end
    end
endmodule