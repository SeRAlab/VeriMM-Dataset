module robot_mapping (
    input clk,
    input rst,
    input [1:0] direction,
    output reg [3:0] x_pos,
    output reg [3:0] y_pos
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        x_pos <= 4'b0000;
        y_pos <= 4'b0000;
    end else begin
        case (direction)
            2'b00: y_pos <= y_pos + 1;  // Move Up
            2'b01: y_pos <= y_pos - 1;  // Move Down
            2'b10: x_pos <= x_pos - 1;  // Move Left
            2'b11: x_pos <= x_pos + 1;  // Move Right
        endcase
    end
end

endmodule