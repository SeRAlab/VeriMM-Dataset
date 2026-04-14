module pwm_generator (  
    input clk,  
    input reset,  
    input [7:0] duty_cycle,  
    output reg pwm_out  
);  
    reg [15:0] counter;  
    parameter MAX_COUNT = 16'd10000; // Considering 100MHz clk for 1kHz PWM  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            pwm_out <= 0;  
        end else begin  
            if (counter < MAX_COUNT) begin  
                counter <= counter + 1;  
            end else begin  
                counter <= 0;  
                pwm_out <= (counter < (duty_cycle * MAX_COUNT / 256)) ? 1'b1 : 1'b0;  
            end  
        end  
    end  
endmodule