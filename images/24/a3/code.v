module watchdog_timer(  
    input clk,  
    input reset_signal,  
    output reg timeout  
);  
    reg [1:0] count;  
    always @(posedge clk or posedge reset_signal) begin  
        if (reset_signal) begin  
            count <= 2'b00;  
            timeout <= 1'b0;  
        end else begin  
            if (count == 2'b11) begin  
                timeout <= 1'b1;  
            end else begin  
                count <= count + 1;  
                timeout <= 1'b0;  
            end  
        end  
    end  
endmodule