module divide_by_4 (  
    input clk,  
    input reset,  
    input [3:0] in,  
    output reg [1:0] out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        out <= 2'b00;  
    else  
        out <= in[3:2]; // Takes the upper 2 bits (assuming in is 4-bits)  
end  

endmodule