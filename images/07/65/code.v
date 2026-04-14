module divide_by_8 (  
    input wire [2:0] in,  
    output reg [2:0] out,  
    input wire clk,  
    input wire rst  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 3'b000;  
        else  
            out <= in >> 3;  
    end  
endmodule