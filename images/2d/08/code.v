module RC_Oscillator(  
    input wire clk,  
    input wire reset,  
    output reg out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        out <= 0;  
    else  
        out <= ~out;  
end  
endmodule