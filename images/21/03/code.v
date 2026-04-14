module SLAM (
    input wire clk,
    input wire reset,
    input wire [1:0] direction, // 00: Up, 01: Down, 10: Left, 11: Right
    output reg [3:0] x_pos,      // x-coordinate
    output reg [3:0] y_pos,      // y-coordinate
    output reg [15:0] visited     // 1-bit for each position (0 to 15)
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_pos <= 4'b0000;
            y_pos <= 4'b0000;
            visited <= 16'b0000000000000000;
        end else begin
            // Update position based on direction
            case (direction)
                2'b00: y_pos <= y_pos + 1; // Move Up
                2'b01: y_pos <= y_pos - 1; // Move Down
                2'b10: x_pos <= x_pos - 1; // Move Left
                2'b11: x_pos <= x_pos + 1; // Move Right
            endcase
            
            // Mark the visited position
            visited[{y_pos, x_pos}] <= 1'b1;
        end
    end
endmodule