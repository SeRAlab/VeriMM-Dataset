module ADC_16bit (  
    input wire clk,  
    input wire enable,  
    input wire [15:0] analog_in,  
    output reg [15:0] digital_out  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            digital_out <= analog_in;  
        end  
    end  
endmodule