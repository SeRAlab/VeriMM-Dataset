module monte_carlo_pi (
    input wire [3:0] total_points,
    input wire [3:0] points_inside_circle,
    output wire [15:0] pi_approximation
);
    assign pi_approximation = (points_inside_circle * 16) / total_points;
endmodule