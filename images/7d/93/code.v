module top_module(
    enable,
    direction,
    speed,
    pwm
);input enable;
    input direction;
    input [3:0] speed;
    output reg pwm; // Changed from wire to reg

    reg [9:0] pulse_width;

    always @(*) begin
        if (enable == 0) begin
            pwm = 0;
            pulse_width = 0;
        end else if (speed < 10) begin
            pwm = 0;
            pulse_width = 0;
        end else if (speed > 100) begin
            pwm = 1;
            pulse_width = 1000;
        end else begin
            pwm = 1;
            pulse_width = (speed - 10) * 10;
        end
    end

    always @(posedge pwm) begin
        if (direction == 0) begin
            pwm <= pulse_width[0]; // Use pulse_width[0] for simplicity, changed from pwm
        end else begin
            pwm <= ~pulse_width[0]; // Use pulse_width[0] for simplicity, changed from pwm
        end
    end

endmodule