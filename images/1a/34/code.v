module robot_navigation (
    input clk,
    input rst,
    input enable,
    input [1:0] direction, // 00: Up, 01: Down, 10: Left, 11: Right
    output reg [1:0] row,   // 0-3
    output reg [1:0] col    // 0-3
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            row <= 2'b00; // Initial position (0,0)
            col <= 2'b00;
        end else if (enable) begin
            case (direction)
                2'b00: if (row > 0) row <= row - 1; // Move Up
                2'b01: if (row < 2'b11) row <= row + 1; // Move Down
                2'b10: if (col > 0) col <= col - 1; // Move Left
                2'b11: if (col < 2'b11) col <= col + 1; // Move Right
            endcase
        end
    end
endmodule