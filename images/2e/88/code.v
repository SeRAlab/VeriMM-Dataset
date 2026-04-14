module divide_by_8 (  
    input clk,  
    input rst,  
    input [2:0] in,  
    output reg [2:0] out  
);  
  
always @(posedge clk or posedge rst) begin  
    if (rst)  
        out <= 3'b000;  
    else begin  
        if (in >= 3'b1000)  
            out <= in / 8;  
        else  
            out <= 3'b000;  
    end  
end  
endmodule