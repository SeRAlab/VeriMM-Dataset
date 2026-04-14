module pwm_generator (  
    input wire clk,  
    input wire rst,  
    input wire [9:0] duty_cycle,  
    output reg pwm_out  
);  
    reg [9:0] counter;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 10'd0;  
            pwm_out <= 1'b0;  
        end else begin  
            if (counter < 10'd1000) begin  
                counter <= counter + 10'd1;  
            end else begin  
                counter <= 10'd0;  
            end  
            pwm_out <= (counter < duty_cycle) ? 1'b1 : 1'b0;  
        end  
    end  
endmodule