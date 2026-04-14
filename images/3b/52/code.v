module sr_latch(  
    input wire clk,  
    input wire S,  
    input wire R,  
    output reg Q  
);  
always @(posedge clk) begin  
    if (S)  
        Q <= 1;  
    else if (R)  
        Q <= 0;  
end  
endmodule