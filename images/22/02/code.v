module watchdog_timer (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] timeout_value,  
    output reg timeout_signal  
);  
    reg [3:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 4'b0000;  
            timeout_signal <= 1'b0;  
        end else begin  
            if (counter < timeout_value) begin  
                counter <= counter + 1;  
                timeout_signal <= 1'b0;  
            end else begin  
                timeout_signal <= 1'b1;  
            end  
        end  
    end  
endmodule