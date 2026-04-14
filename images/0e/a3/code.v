module fan_speed_control(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] temperature,  
    output reg [1:0] fan_speed // 00: Off, 01: Low, 10: Medium, 11: High  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            fan_speed <= 2'b00; // Off  
        else begin  
            if (temperature < 20)  
                fan_speed <= 2'b01; // Low  
            else if (temperature >= 20 && temperature <= 30)  
                fan_speed <= 2'b10; // Medium  
            else  
                fan_speed <= 2'b11; // High  
        end  
    end  
endmodule