module temperature_shutdown (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] temperature,  
    input wire [7:0] threshold,  
    output reg shutdown  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            shutdown <= 0;  
        else if (temperature > threshold)  
            shutdown <= 1;  
    end  
endmodule