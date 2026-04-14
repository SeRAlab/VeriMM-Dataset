module divide_by_2(  
    input clk,  
    input enable,  
    input reset,  
    output reg out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 1'b0;  
        end else if (enable) begin  
            out <= ~out;  
        end  
    end  
endmodule