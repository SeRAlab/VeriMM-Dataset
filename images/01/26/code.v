module monte_carlo_pi(
    input [7:0] x,
    input [7:0] y,
    output reg is_inside
);
    always @(*) begin
        // Calculate x^2 + y^2
        if ((x * x + y * y) <= 8'hFF) // A point (x, y) is inside the unit circle if x^2 + y^2 <= 1
            is_inside = 1'b1;
        else
            is_inside = 1'b0;
    end
endmodule