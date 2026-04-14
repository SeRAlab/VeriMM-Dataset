module temperature_sensor(input clk, input [7:0] temp, input [7:0] threshold, output reg alert);  
    always @(posedge clk) begin  
        if (temp > threshold)  
            alert <= 1'b1;  
        else  
            alert <= 1'b0;  
    end  
endmodule