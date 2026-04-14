module divide_by_8 (  
    input wire clk,  
    input wire [2:0] in,  
    output reg [2:0] out  
);  
    always @(posedge clk) begin  
        out <= in / 8;  
    end  
endmodule