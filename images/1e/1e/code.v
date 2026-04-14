module temp_shutdown_system(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg shutdown_signal  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown_signal <= 0;  
        end else if (temperature > 8'd75) begin  
            shutdown_signal <= 1;  
        end  
    end  
endmodule