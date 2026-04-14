module watchdog_timer #(parameter TIMEOUT = 10) (  
    input clk,  
    input reset,  
    output reg timeout  
);  
    reg [3:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            timeout <= 0;  
        end else begin  
            if (counter < TIMEOUT) begin  
                counter <= counter + 1;  
                timeout <= 0;  
            end else begin  
                timeout <= 1;  
            end  
        end  
    end  
endmodule