module dff_with_reset_enable(  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire D,  
    output reg Q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            Q <= 1'b0;  
        end else if (enable) begin  
            Q <= D;  
        end  
    end  
endmodule