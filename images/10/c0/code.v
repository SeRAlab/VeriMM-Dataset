module hough_transform (
    input [7:0] x_in,
    input [7:0] y_in,
    input valid,
    output reg [7:0] r_out,
    output reg [7:0] theta_out,
    output reg line_detected
);
    always @(*) begin
        if (valid) begin
            if (x_in == 0) begin // vertical line
                r_out = y_in;
                theta_out = 90; // angle in degrees
                line_detected = 1;
            end else if (y_in == 0) begin // horizontal line
                r_out = x_in;
                theta_out = 0; // angle in degrees
                line_detected = 1;
            end else begin
                line_detected = 0; // no line detected
            end
        end else begin
            line_detected = 0; // no valid input
        end
    end
endmodule