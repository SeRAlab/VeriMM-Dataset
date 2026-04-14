module vco (  
    input wire [2:0] control_voltage,  
    output reg frequency_output  
);  

    always @(control_voltage) begin  
        if (control_voltage < 3'b100)  
            frequency_output = 1'b0; // Low frequency  
        else  
            frequency_output = 1'b1; // High frequency  
    end  
endmodule