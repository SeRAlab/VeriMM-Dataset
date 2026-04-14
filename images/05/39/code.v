module divide_by_2(  
    input wire clk,  
    input wire rst,  
    input wire in,  
    output reg out  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        out <= 0;  
    end else begin  
        out <= in >> 1; // Divide by 2  
    end  
end  
endmodule