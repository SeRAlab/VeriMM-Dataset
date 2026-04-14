module fan_speed_control(  
    input wire clk,  
    input wire [7:0] temperature,  
    output reg [1:0] fan_speed  
);  
    always @(posedge clk) begin  
        if (temperature < 20)  
            fan_speed <= 2'b00; // Low speed  
        else if (temperature >= 20 && temperature <= 30)  
            fan_speed <= 2'b01; // Medium speed  
        else  
            fan_speed <= 2'b10; // High speed  
    end  
endmodule