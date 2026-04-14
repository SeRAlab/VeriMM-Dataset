module temp_shutdown(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg shutdown_signal  
);  
    parameter THRESHOLD = 8'd75;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            shutdown_signal <= 0;  
        else if (temperature > THRESHOLD)  
            shutdown_signal <= 1;  
        else  
            shutdown_signal <= 0;  
    end  
endmodule