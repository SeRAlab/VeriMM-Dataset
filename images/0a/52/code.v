module temp_shutdown(  
    input clk,  
    input reset,  
    input [7:0] temperature,  
    output reg shutdown  
);  
    parameter TEMP_LIMIT = 8'd100;  
    parameter THRESHOLD_CYCLES = 4;  
    reg [3:0] count;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 0;  
            count <= 0;  
        end else begin  
            if (temperature > TEMP_LIMIT) begin  
                count <= count + 1;  
                if (count >= THRESHOLD_CYCLES)  
                    shutdown <= 1;  
            end else begin  
                count <= 0;  
                shutdown <= 0;  
            end  
        end  
    end  
endmodule