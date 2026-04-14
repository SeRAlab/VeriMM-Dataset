module adc_24_to_12 (  
    input wire clk,  
    input wire enable,  
    input wire [23:0] analog_input,  
    output reg [11:0] digital_output  
);  

    always @(posedge clk) begin  
        if (enable) begin  
            digital_output <= analog_input / 4096;  
        end  
    end  
endmodule