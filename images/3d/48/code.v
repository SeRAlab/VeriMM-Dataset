module DAC_24bit (  
    input [23:0] input_value,  
    input [23:0] V_ref,  
    output reg [23:0] V_out  
);  
    always @(*) begin  
        V_out = (input_value * V_ref) >> 24;  
    end  
endmodule