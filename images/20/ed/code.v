module cordic_rotation (
    input [3:0] angle,
    input [3:0] x_in,
    input [3:0] y_in,
    output reg [3:0] x_out,
    output reg [3:0] y_out
);

always @(*) begin
    case (angle)
        4'b0000: begin // 0 degrees
            x_out = x_in;
            y_out = y_in;
        end
        4'b0001: begin // 45 degrees
            x_out = (x_in - y_in) >> 1; 
            y_out = (x_in + y_in) >> 1;
        end
        4'b0010: begin // 90 degrees
            x_out = -y_in;
            y_out = x_in;
        end
        4'b0011: begin // 135 degrees
            x_out = (-x_in - y_in) >> 1;
            y_out = (y_in - x_in) >> 1;
        end
        4'b0100: begin // 180 degrees
            x_out = -x_in;
            y_out = -y_in;
        end
        default: begin // Invalid angle
            x_out = 4'b0000;
            y_out = 4'b0000;
        end
    endcase
end

endmodule