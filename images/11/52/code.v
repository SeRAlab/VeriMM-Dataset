module reset_controller (  
    input clk,  
    input reset,  
    input enable,  
    output reg out  
);  
    reg [1:0] delay;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 0;  
            delay <= 0;  
        end else if (enable) begin  
            if (delay < 2) begin  
                delay <= delay + 1;  
            end else begin  
                out <= 1;  
            end  
        end  
    end  
endmodule