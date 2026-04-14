module monte_carlo_pi (
    input [15:0] random_x,
    input [15:0] random_y,
    input clk,
    input start,
    output reg [31:0] pi_estimate,
    output reg finished
);
    reg [31:0] inside_circle = 0;
    reg [31:0] total_points = 0;

    always @(posedge clk) begin
        if (start) begin
            total_points <= total_points + 1;
            if ((random_x * random_x + random_y * random_y) <= (1 << 16)) // Check if inside circle
                inside_circle <= inside_circle + 1;

            if (total_points > 0) 
                pi_estimate <= (inside_circle * 4) / total_points; // Estimate π
            finished <= 1;
        end
        else begin
            finished <= 0;
        end
    end
endmodule