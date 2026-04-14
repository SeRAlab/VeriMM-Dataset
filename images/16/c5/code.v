module temperature_shutdown (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] temperature,  
    input wire [7:0] threshold,  
    output reg shutdown  
);  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shutdown <= 0;  
        end else begin  
            if (temperature > threshold) begin  
                shutdown <= 1;  
            end else begin  
                shutdown <= 0;  
            end  
        end  
    end  
endmodule