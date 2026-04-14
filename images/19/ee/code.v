module watchdog_timer (  
    input clk,  
    input reset,  
    input start,  
    input stop,  
    output reg timeout  
);  
    reg [3:0] counter;  // 4-bit counter for timeout period  
    parameter TIMEOUT_VALUE = 4'b1111; // Set timeout value to 15 (for example)  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            timeout <= 0;  
        end  
        else if (start && !stop) begin  
            if (counter < TIMEOUT_VALUE) begin  
                counter <= counter + 1;  
                timeout <= 0;  
            end  
            else begin  
                timeout <= 1;  
            end  
        end  
        else if (stop) begin  
            counter <= 0;  
            timeout <= 0;  
        end  
    end  
endmodule