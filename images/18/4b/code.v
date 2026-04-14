module temperature_shutdown(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    input wire [7:0] threshold,  
    output reg shutdown  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 1'b0;  
        end else if (temperature > threshold) begin  
            shutdown <= 1'b1;  
        end else begin  
            shutdown <= 1'b0;  
        end  
    end  
endmodule