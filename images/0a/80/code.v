module frequency_divider(  
    input wire clk,  
    input wire reset,  
    output reg q  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        q <= 0;  
    else  
        q <= ~q;  
end  
endmodule