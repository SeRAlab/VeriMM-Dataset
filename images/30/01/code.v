module adc_interface(  
    input wire clk,  
    input wire [15:0] adc_input,  
    output reg [15:0] adc_output  
);  
    always @(posedge clk) begin  
        adc_output <= adc_input;  
    end  
endmodule