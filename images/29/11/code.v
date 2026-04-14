module temperature_shutdown(  
    input clk,  
    input rst,  
    input [7:0] temperature,  
    input [7:0] threshold,  
    output reg shutdown  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shutdown <= 0;  
        end else begin  
            if (temperature > threshold)  
                shutdown <= 1;  
            else  
                shutdown <= 0;  
        end  
    end  
endmodule