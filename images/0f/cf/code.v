module RobotMovement(
    input [3:0] x_in,
    input [3:0] y_in,
    input [1:0] direction,
    output reg [3:0] x_out,
    output reg [3:0] y_out
);
    always @(*) begin
        case (direction)
            2'b00: begin // North
                x_out = x_in;
                y_out = (y_in < 15) ? (y_in + 1) : y_in; // move up
            end
            2'b01: begin // East
                x_out = (x_in < 15) ? (x_in + 1) : x_in; // move right
                y_out = y_in;
            end
            2'b10: begin // South
                x_out = x_in;
                y_out = (y_in > 0) ? (y_in - 1) : y_in; // move down
            end
            2'b11: begin // West
                x_out = (x_in > 0) ? (x_in - 1) : x_in; // move left
                y_out = y_in;
            end
            default: begin
                x_out = x_in;
                y_out = y_in;
            end
        endcase
    end
endmodule