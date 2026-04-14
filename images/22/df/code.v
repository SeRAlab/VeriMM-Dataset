module watchdog_timer(  
    input clk,  
    input reset,  
    input [3:0] timeout,  
    output reg sys_reset  
);  
    reg [3:0] counter;  
    reg timeout_expired;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            sys_reset <= 0;  
            timeout_expired <= 0;  
        end else begin  
            if (counter < timeout) begin  
                counter <= counter + 1;  
                sys_reset <= 0;  
                timeout_expired <= 0;  
            end else begin  
                sys_reset <= 1;  
                timeout_expired <= 1;  
            end  
        end  
    end  
endmodule