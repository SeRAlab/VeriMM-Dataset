module slam_system (
    input clk,
    input reset,
    input [7:0] sensor_reading,
    input [1:0] control_command, // 00: No movement, 01: Move Up, 10: Move Down, 11: Move Right
    output reg [7:0] pos_x,
    output reg [7:0] pos_y
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos_x <= 8'd0;
            pos_y <= 8'd0;
        end else begin
            case (control_command)
                2'b00: begin // No movement
                    // Do nothing
                end
                2'b01: begin // Move Up
                    pos_y <= pos_y + 1;
                end
                2'b10: begin // Move Down
                    pos_y <= pos_y - 1;
                end
                2'b11: begin // Move Right
                    pos_x <= pos_x + 1;
                end
            endcase
        end
    end
endmodule