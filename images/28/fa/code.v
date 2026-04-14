module adc_controller(  
    input clk,  
    input enable,  
    input [23:0] adc_input,  
    output reg [23:0] adc_output  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            adc_output <= adc_input << 2;  
        end  
    end  
endmodule