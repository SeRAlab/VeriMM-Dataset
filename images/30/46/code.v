module switching_regulator_controller (  
    input clk,  
    input rst,  
    input [7:0] Vin, // Input voltage  
    input [7:0] Vfb, // Feedback voltage  
    input [7:0] Vtarget, // Target voltage  
    output reg [7:0] duty_cycle // PWM duty cycle output  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            duty_cycle <= 8'b0;  
        end else begin  
            if (Vfb < Vtarget) begin  
                duty_cycle <= duty_cycle + 1; // Increase duty cycle  
            end else if (Vfb > Vtarget) begin  
                duty_cycle <= duty_cycle - 1; // Decrease duty cycle  
            end  
        end  
    end  
endmodule