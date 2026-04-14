module rrt_controller(
    input clk,
    input reset,
    input enable,
    output reg [2:0] x, // x-coordinate (0 to 4)
    output reg [2:0] y, // y-coordinate (0 to 4)
    output reg valid
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 3'b000;
            y <= 3'b000;
            valid <= 1'b0;
        end else if (enable) begin
            // Generate random point (for simplicity, we use a simple counter as pseudo-random)
            x <= (x + 1) % 5; // Pseudo-random for demonstration
            y <= (y + 2) % 5; // Pseudo-random for demonstration
            valid <= (x < 5 && y < 5); // Check if within bounds
        end
    end
endmodule