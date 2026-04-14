module divide_by_8 (  
    input wire clk,  
    input wire rst,  
    input wire [2:0] in,  
    output reg out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out <= 1'b0;  
        end else begin  
            out <= 1'b0; // since in will always be less than 8  
        end  
    end  
endmodule