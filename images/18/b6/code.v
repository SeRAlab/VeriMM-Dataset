module switching_regulator(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] desired_voltage,  
    input wire [7:0] actual_voltage,  
    output reg pwm_signal  
);  
    reg [7:0] error;  
    reg [7:0] duty_cycle;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            duty_cycle <= 8'b0;  
            pwm_signal <= 1'b0;  
        end else begin  
            error <= desired_voltage - actual_voltage;  
            if (error > 8'd0) begin  
                duty_cycle <= duty_cycle + 1;  
                if (duty_cycle > 8'd255)  
                    duty_cycle <= 8'd255;  
            end else if (error < 8'd0) begin  
                duty_cycle <= duty_cycle - 1;  
                if (duty_cycle < 8'd0)  
                    duty_cycle <= 8'd0;  
            end  
            pwm_signal <= (duty_cycle > 8'd128) ? 1'b1 : 1'b0;  
        end  
    end  
endmodule