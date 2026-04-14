module top_module(
    input clk,
    input rst,
    input [5:0] cmd,
    input [5:0] current_angles,
    output reg joint0_pwm,
    output reg joint1_pwm,
    output reg joint2_pwm,
    output reg joint3_pwm,
    output reg joint4_pwm,
    output reg joint5_pwm
);// Define constants for PWM generation
parameter PERIOD = 100;
parameter MAX_DUTY_CYCLE = 90;

// Define variables for joint angles
reg [5:0] joint0_angle;
reg [5:0] joint1_angle;
reg [5:0] joint2_angle;
reg [5:0] joint3_angle;
reg [5:0] joint4_angle;
reg [5:0] joint5_angle;

// Initialize joint angles to current_angles
always @(posedge rst) begin
    joint0_angle <= current_angles[0];
    joint1_angle <= current_angles[1];
    joint2_angle <= current_angles[2];
    joint3_angle <= current_angles[3];
    joint4_angle <= current_angles[4];
    joint5_angle <= current_angles[5];
end

// Update joint angles based on cmd input
always @(posedge clk) begin
    if (cmd[0] != 0) joint0_angle <= cmd[0];
    if (cmd[1] != 0) joint1_angle <= cmd[1];
    if (cmd[2] != 0) joint2_angle <= cmd[2];
    if (cmd[3] != 0) joint3_angle <= cmd[3];
    if (cmd[4] != 0) joint4_angle <= cmd[4];
    if (cmd[5] != 0) joint5_angle <= cmd[5];
end

// Generate PWM signals for each joint based on its angle
always @(posedge clk) begin
    joint0_pwm <= (joint0_angle * MAX_DUTY_CYCLE) / 180;
    joint1_pwm <= (joint1_angle * MAX_DUTY_CYCLE) / 180;
    joint2_pwm <= (joint2_angle * MAX_DUTY_CYCLE) / 180;
    joint3_pwm <= (joint3_angle * MAX_DUTY_CYCLE) / 180;
    joint4_pwm <= (joint4_angle * MAX_DUTY_CYCLE) / 180;
    joint5_pwm <= (joint5_angle * MAX_DUTY_CYCLE) / 180;
end

endmodule