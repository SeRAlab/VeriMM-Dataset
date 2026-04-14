module monte_carlo_pi(
    input [7:0] x, // x coordinate (0 to 255)
    input [7:0] y, // y coordinate (0 to 255)
    input valid,    // signal to indicate input is valid
    output reg [15:0] pi_estimate // estimated value of π * 10000 for precision
);
    reg [31:0] inside_circle;
    reg [31:0] total_points;

    always @(posedge valid) begin
        total_points <= total_points + 1;
        if ((x * x + y * y) <= (255 * 255)) begin
            inside_circle <= inside_circle + 1;
        end
        pi_estimate <= (inside_circle * 40000) / total_points; // π * 10000
    end
endmodule