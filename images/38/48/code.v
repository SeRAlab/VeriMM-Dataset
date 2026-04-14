module fan_speed_control (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg [1:0] fan_speed // 00: off, 01: low, 10: high  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            fan_speed <= 2'b00; // fan off  
        end else begin  
            if (temperature < 8'd20) begin  
                fan_speed <= 2'b00; // fan off  
            end else if (temperature >= 8'd20 && temperature < 8'd30) begin  
                fan_speed <= 2'b01; // low speed  
            end else begin  
                fan_speed <= 2'b10; // high speed  
            end  
        end  
    end  
endmodule