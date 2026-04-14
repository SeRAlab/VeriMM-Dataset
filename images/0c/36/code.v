module divide_by_2 (  
    input wire clk,  
    input wire reset,  
    input wire in,  
    output reg out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 0;  
        end else begin  
            out <= in;  
        end  
    end  
endmodule