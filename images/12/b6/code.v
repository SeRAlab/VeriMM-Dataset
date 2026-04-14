module monte_carlo_pi (
    input [4:0] point_x,
    input [4:0] point_y,
    output reg inside_circle
);
    always @(*) begin
        // Check if the point (point_x, point_y) is inside the quarter circle
        if ((point_x * point_x + point_y * point_y) <= 25) // 5^2 = 25
            inside_circle = 1'b1; // Point is inside the quarter circle
        else
            inside_circle = 1'b0; // Point is outside the quarter circle
    end
endmodule