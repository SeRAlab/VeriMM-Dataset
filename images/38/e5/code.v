module divide_by_4 (  
    input clk,  
    input reset,  
    input [3:0] in,  
    output reg [1:0] out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 2'b00;  
        end else begin  
            out <= in[3:2]; // Take the upper 2 bits as the result of division by 4  
        end  
    end  
endmodule