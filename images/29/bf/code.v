module watchdog_timer(  
    input wire clk,  
    input wire reset_signal,  
    input wire [3:0] timeout_period,  
    output reg timeout  
);  
    reg [3:0] counter;  

    always @(posedge clk) begin  
        if (reset_signal) begin  
            counter <= 0;  
            timeout <= 0;  
        end else if (counter < timeout_period) begin  
            counter <= counter + 1;  
            timeout <= 0;  
        end else begin  
            timeout <= 1;  
        end  
    end  
endmodule