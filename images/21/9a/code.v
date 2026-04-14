module pwm_generator(  
    input clk,  
    input reset,  
    input [3:0] duty_cycle,  
    output reg pwm_out  
);  
    reg [9:0] counter; // 10-bit counter for PWM timing  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            pwm_out <= 0;  
        end else begin  
            if (counter < 1000) begin  
                counter <= counter + 1;  
            end else begin  
                counter <= 0;  
            end  
            pwm_out <= (counter < (duty_cycle * 1000 / 16));  
        end  
    end  
endmodule