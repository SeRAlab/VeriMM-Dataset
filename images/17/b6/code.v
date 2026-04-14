module watchdog_timer(  
    input clk,  
    input reset,  
    input [3:0] timeout_value,  
    output reg timeout_output  
);  
    reg [3:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            timeout_output <= 0;  
        end else if (counter == timeout_value) begin  
            timeout_output <= 1;  
        end else begin  
            counter <= counter + 1;  
            timeout_output <= 0;  
        end  
    end  
endmodule