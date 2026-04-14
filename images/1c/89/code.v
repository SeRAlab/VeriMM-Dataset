module clock_gating_ff(  
    input wire clk,  
    input wire enable,  
    input wire d,  
    output reg q  
);  
    always @(posedge clk) begin  
        if (enable)  
            q <= d;  
    end  
endmodule