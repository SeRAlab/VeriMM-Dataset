module watchdog_timer(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] timeout_value,  
    output reg timeout_signal  
);  
    reg [3:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= timeout_value;  
            timeout_signal <= 0;  
        end else begin  
            if (counter > 0) begin  
                counter <= counter - 1;  
            end  
            if (counter == 0) begin  
                timeout_signal <= 1;  
            end  
        end  
    end  
endmodule