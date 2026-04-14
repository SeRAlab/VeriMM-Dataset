module DAC_24bit (  
    input [23:0] data_in,  
    input valid,  
    output reg [3:0] data_out  
);  

always @(*) begin  
    if (valid)  
        data_out = (data_in >> 20) & 4'b1111;  
    else  
        data_out = 4'b0000;  
end  
endmodule