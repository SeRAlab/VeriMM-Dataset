module temp_shutdown_controller (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] temperature,  
    output reg shutdown  
);  
    parameter THRESHOLD = 8'd75;  // Temperature threshold for shutdown  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shutdown <= 1'b0;  
        end else if (temperature > THRESHOLD) begin  
            shutdown <= 1'b1;  
        end  
    end  
endmodule