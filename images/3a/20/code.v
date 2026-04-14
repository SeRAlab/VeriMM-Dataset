module watchdog_timer (  
    input wire clk,  
    input wire reset_n,  
    input wire kick,  
    output reg reset  
);  
    parameter TIMEOUT = 10; // Set the timeout period  
    reg [3:0] counter; // 4-bit counter to hold timeout  

    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            counter <= 0;  
            reset <= 1;  
        end else if (kick) begin  
            counter <= 0;  
            reset <= 0;  
        end else if (counter < TIMEOUT) begin  
            counter <= counter + 1;  
            reset <= 0;  
        end else begin  
            reset <= 1;  
        end  
    end  
endmodule