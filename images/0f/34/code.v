module fan_speed_control (
    input wire clk,
    input wire rst,
    input wire [1:0] speed_setting,
    output reg [2:0] fan_speed
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        fan_speed <= 3'b000; // Off
    end else begin
        case (speed_setting)
            2'b00: fan_speed <= 3'b000; // Off
            2'b01: fan_speed <= 3'b001; // Low speed
            2'b10: fan_speed <= 3'b010; // Medium speed
            2'b11: fan_speed <= 3'b011; // High speed
            default: fan_speed <= 3'b000; // Default to Off
        endcase
    end
end
endmodule