module temperature_sensor(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg alert  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            alert <= 0;  
        end else if (temperature > 8'd75) begin  
            alert <= 1;  
        end else begin  
            alert <= 0;  
        end  
    end  
endmodule