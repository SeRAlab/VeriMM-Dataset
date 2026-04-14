module temperature_shutdown(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg shutdown  
);  
    parameter THRESHOLD = 8'd80;  
    parameter SAFE_TEMP = 8'd70;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 1'b0;  
        end else if (temperature > THRESHOLD) begin  
            shutdown <= 1'b1;  
        end else if (temperature < SAFE_TEMP) begin  
            shutdown <= 1'b0;  
        end  
    end  
endmodule