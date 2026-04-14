module fan_speed_control(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg [1:0] fan_speed  
);  
    parameter OFF = 2'b00, LOW = 2'b01, HIGH = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            fan_speed <= OFF;  
        else begin  
            if (temperature < 20)  
                fan_speed <= OFF;  
            else if (temperature >= 20 && temperature <= 30)  
                fan_speed <= LOW;  
            else  
                fan_speed <= HIGH;  
        end  
    end  
endmodule