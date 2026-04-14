module monte_carlo_pi (
    input wire [7:0] x, // x coordinate
    input wire [7:0] y, // y coordinate
    input wire throw,    // signal to indicate a dart throw
    output reg inside,   // 1 if inside the circle, 0 otherwise
    output reg [31:0] count // total number of darts thrown
);
    
    always @(*) begin
        if (throw) begin
            count = count + 1;
            // Check if the dart is inside the unit circle (x^2 + y^2 < 1)
            inside = (x * x + y * y < 256); // 256 = 16^2, since x and y are 8-bit
        end else begin
            inside = inside; // Maintain previous state if not throwing
        end
    end
endmodule