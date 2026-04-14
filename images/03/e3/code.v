module temperature_shutdown(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg shutdown  
);  
    parameter THRESHOLD = 8'd75;  // Define the temperature threshold

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 0;  
        end else begin  
            if (temperature > THRESHOLD) begin  
                shutdown <= 1;  
            end else begin  
                shutdown <= 0;  
            end  
        end  
    end  
endmodule