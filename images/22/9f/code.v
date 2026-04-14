module temp_shutdown(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] temperature,  
    output reg shutdown  
);  
    parameter THRESHOLD = 8'd75;  
    parameter SAFE_TEMP = 8'd70;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shutdown <= 1'b0;  
        end else begin  
            if (temperature > THRESHOLD) begin  
                shutdown <= 1'b1;  
            end else if (temperature < SAFE_TEMP) begin  
                shutdown <= 1'b0;  
            end  
        end  
    end  
endmodule