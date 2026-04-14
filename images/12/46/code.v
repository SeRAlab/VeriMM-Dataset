module temperature_shutdown(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg shutdown_signal  
);  
  
    parameter THRESHOLD = 8'd75; // Temperature threshold for shutdown  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown_signal <= 1'b0;  
        end else if (temperature > THRESHOLD) begin  
            shutdown_signal <= 1'b1;  
        end else begin  
            shutdown_signal <= 1'b0;  
        end  
    end  
endmodule