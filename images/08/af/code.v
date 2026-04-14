module ldo_regulator(  
    input wire enable,  
    input wire [5:0] vin,  // Input voltage in binary (6 bits)  
    output reg [5:0] vout  // Output voltage in binary (6 bits)  
);  
    parameter TARGET_VOUT = 6'b011010; // 3.3V in 6-bit binary representation  
    always @(*) begin  
        if (enable) begin  
            if (vin >= TARGET_VOUT)  
                vout = TARGET_VOUT;  
            else  
                vout = vin;  
        end else begin  
            vout = 6'b000000; // Output is 0V when disabled  
        end  
    end  
endmodule