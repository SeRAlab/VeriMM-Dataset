module fan_speed_controller (
    input clk,
    input rst,
    input [1:0] speed_input,
    input enable,
    output reg [1:0] fan_speed
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Fan stopped by default
        end else if (enable) begin
            case (speed_input)
                2'b00: fan_speed <= 2'b00; // Low Speed
                2'b01: fan_speed <= 2'b01; // Medium Speed
                2'b10: fan_speed <= 2'b10; // High Speed
                default: fan_speed <= 2'b00; // Default to Low Speed
            endcase
        end else begin
            fan_speed <= 2'b00; // Fan stops when not enabled
        end
    end
endmodule