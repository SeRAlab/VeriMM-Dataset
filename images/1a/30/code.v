module adc_comparator(  
    input [15:0] signal_a,  
    input [15:0] signal_b,  
    output reg greater  
);  

always @(*) begin  
    if (signal_a > signal_b)  
        greater = 1;  
    else  
        greater = 0;  
end  
endmodule