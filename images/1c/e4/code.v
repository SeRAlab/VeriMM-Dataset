module divide_by_4(  
    input clk,  
    input rst,  
    input [1:0] in,  
    output reg [1:0] out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out <= 2'b00;  
        end else begin  
            out <= in >> 2;  
        end  
    end  
endmodule