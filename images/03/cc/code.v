module linear_voltage_regulator(  
    input wire [7:0] ref_voltage,  
    input wire enable,  
    output reg [7:0] out_voltage  
);  

always @(*) begin  
    if (enable) begin  
        if (ref_voltage < 8'd100)  
            out_voltage = ref_voltage;  
        else  
            out_voltage = 8'd100;  
    end else begin  
        out_voltage = 8'd0;  
    end  
end  
endmodule