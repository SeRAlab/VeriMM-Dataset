module DAC_24bit (  
    input [23:0] din,  
    output reg [23:0] dout  
);  
    always @(*) begin  
        dout = din;  
    end  
endmodule