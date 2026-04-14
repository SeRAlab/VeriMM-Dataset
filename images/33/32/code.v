module temperature_sensor (  
    input wire clk,  
    input wire [3:0] temperature,  
    output reg alarm  
);  
    parameter THRESHOLD = 4'd8;  
  
    always @(posedge clk) begin  
        if (temperature > THRESHOLD)  
            alarm <= 1'b1;  
        else  
            alarm <= 1'b0;  
    end  
endmodule