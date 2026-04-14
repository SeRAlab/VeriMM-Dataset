module slam (
    input clk,
    input rst,
    input [1:0] direction,
    input [1:0] distance,
    output reg [7:0] pos_x,
    output reg [7:0] pos_y
);

    initial begin
        pos_x = 8'b00000000;
        pos_y = 8'b00000000;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pos_x <= 8'b00000000;
            pos_y <= 8'b00000000;
        end else begin
            case (direction)
                2'b00: pos_y <= pos_y + distance; // North
                2'b01: pos_x <= pos_x + distance; // East
                2'b10: pos_y <= pos_y - distance; // South
                2'b11: pos_x <= pos_x - distance; // West
            endcase
        end
    end
endmodule