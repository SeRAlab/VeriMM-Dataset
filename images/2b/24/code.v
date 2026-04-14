module divide_by_8(  
    input clk,  
    input rst,  
    input [2:0] in,  
    output reg [2:0] out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out <= 3'b000;  
        end else begin  
            out <= in / 3'd8;  
        end  
    end  
endmodule