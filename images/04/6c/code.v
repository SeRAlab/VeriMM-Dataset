module d_latch (  
    input wire D,  
    input wire clk,  
    input wire enable,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (enable)  
            Q <= D;  
    end  
endmodule