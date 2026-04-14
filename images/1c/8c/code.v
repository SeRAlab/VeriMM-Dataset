module watchdog_timer (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire system_ok,  
    output reg timeout  
);  
    reg [2:0] counter; // 3-bit counter for up to 7 cycles  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 3'b000;  
            timeout <= 0;  
        end else if (enable) begin  
            if (!system_ok) begin  
                counter <= counter + 1;  
                if (counter == 3'b101) // 5 cycles  
                    timeout <= 1;  
            end else begin  
                counter <= 3'b000;  
                timeout <= 0;  
            end  
        end  
    end  
endmodule