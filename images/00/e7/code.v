module divide_by_4(  
    input [1:0] in,  
    input clk,  
    output reg [1:0] out  
);  
    always @(posedge clk) begin  
        out <= in / 4;  
    end  
endmodule