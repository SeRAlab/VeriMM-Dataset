module fan_speed_controller (  
    input clk,  
    input reset,  
    input [2:0] desired_speed,  
    output reg [2:0] actual_speed  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            actual_speed <= 3'b000;  
        end else begin  
            if (actual_speed < desired_speed)  
                actual_speed <= actual_speed + 1;  
            else if (actual_speed > desired_speed)  
                actual_speed <= actual_speed - 1;  
        end  
    end  
endmodule