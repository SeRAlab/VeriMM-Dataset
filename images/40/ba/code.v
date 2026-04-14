module watchdog_timer(  
    input wire clk,  
    input wire rst,  
    input wire enable,  
    input wire reset_signal,  
    output reg timeout  
);  
    parameter TIMEOUT_VALUE = 4'd10;  
    reg [3:0] counter;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 4'd0;  
            timeout <= 1'b0;  
        end else if (enable) begin  
            if (reset_signal) begin  
                counter <= 4'd0;  
                timeout <= 1'b0;  
            end else begin  
                if (counter < TIMEOUT_VALUE) begin  
                    counter <= counter + 1;  
                end else begin  
                    timeout <= 1'b1;  
                end  
            end  
        end  
    end  
endmodule