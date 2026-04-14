module fan_speed_control (
    input wire clk,
    input wire rst,
    input wire [2:0] desired_speed,
    input wire fan_on,
    output reg [2:0] current_speed
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_speed <= 3'b000; // Reset current speed to 0
    end else if (fan_on) begin
        current_speed <= desired_speed; // Set current speed to desired speed
    end else begin
        current_speed <= 3'b000; // Turn off the fan
    end
end

endmodule