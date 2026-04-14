module top_module(
    input [7:0] servo1_angle,
    input [7:0] servo2_angle,
    input [7:0] servo3_angle,
    input [7:0] servo4_angle,
    input [7:0] servo5_angle,
    output reg [11:0] servo1_pwm,
    output reg [11:0] servo2_pwm,
    output reg [11:0] servo3_pwm,
    output reg [11:0] servo4_pwm,
    output reg [11:0] servo5_pwm
);always @(*) begin
        servo1_pwm = (servo1_angle * 11) + 500;
        servo2_pwm = (servo2_angle * 11) + 500;
        servo3_pwm = (servo3_angle * 11) + 500;
        servo4_pwm = (servo4_angle * 11) + 500;
        servo5_pwm = (servo5_angle * 11) + 500;
    end

endmodule