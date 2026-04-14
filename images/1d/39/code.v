module watchdog_timer(  
    input wire clk,  
    input wire reset,  
    input wire timeout,  
    output reg timeout_signal  
);  
    reg [3:0] counter; // 4-bit counter for timeout duration  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            timeout_signal <= 0;  
        end else if (timeout) begin  
            counter <= counter + 1;  
            if (counter == 4'b1111) begin // Timeout after 16 clock cycles  
                timeout_signal <= 1;  
            end  
        end  
    end  
endmodule