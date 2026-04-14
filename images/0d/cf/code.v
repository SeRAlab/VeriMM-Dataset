module watchdog_timer (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] timeout,  
    output reg safe_state  
);  
    reg [3:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            safe_state <= 1'b1;  
        end else if (counter < timeout) begin  
            counter <= counter + 1;  
            safe_state <= 1'b1;  
        end else begin  
            safe_state <= 1'b0;  
        end  
    end  
endmodule