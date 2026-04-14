module SLAM (
    input clk,
    input reset,
    input [1:0] direction, // 00: North, 01: East, 10: South, 11: West
    input [7:0] distance,   // Distance to move (0-255)
    output reg signed [15:0] x, // Current x coordinate
    output reg signed [15:0] y  // Current y coordinate
);
    
    initial begin
        x = 0;
        y = 0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 0;
            y <= 0;
        end else begin
            case (direction)
                2'b00: y <= y + distance;  // Move North
                2'b01: x <= x + distance;  // Move East
                2'b10: y <= y - distance;  // Move South
                2'b11: x <= x - distance;  // Move West
            endcase
        end
    end
endmodule