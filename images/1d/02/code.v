module divide_by_2(  
    input wire clk,  
    input wire rst,  
    output reg out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out <= 0;  
        end else begin  
            out <= ~out;  
        end  
    end  
endmodule