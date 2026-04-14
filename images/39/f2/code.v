module ADC_Converter (  
    input [15:0] binary_in,  
    output reg [15:0] decimal_out  
);  
    always @(*) begin  
        decimal_out = binary_in;  
    end  
endmodule