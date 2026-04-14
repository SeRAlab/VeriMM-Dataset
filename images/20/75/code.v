module vco (  
    input [3:0] control_voltage,  
    output reg [3:0] frequency_output  
);  
    always @(control_voltage) begin  
        frequency_output <= control_voltage << 1; // frequency_output = 2 * control_voltage  
    end  
endmodule