module switching_regulator (
    input wire clk,
    input wire rst,
    input wire [7:0] desired_voltage,    // Desired output voltage
    input wire [7:0] measured_voltage,    // Measured output voltage
    output reg [7:0] duty_cycle           // PWM duty cycle
);

    reg [7:0] error;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            duty_cycle <= 8'b0;
        end else begin
            error <= desired_voltage - measured_voltage;
            if (error > 8'b0) begin
                duty_cycle <= duty_cycle + (error >> 1);  // Increase duty cycle based on error
            end else if (error < 8'b0) begin
                duty_cycle <= duty_cycle - (error >> 1);  // Decrease duty cycle based on error
            end
        end
    end
endmodule