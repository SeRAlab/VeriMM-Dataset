module voltage_regulator(  
    input [2:0] V_in,  
    output reg [2:0] V_out  
);  
    always @(*) begin  
        if (V_in < 3'b111)  
            V_out = V_in + 3'b001;  
        else  
            V_out = 3'b111;  
    end  
endmodule