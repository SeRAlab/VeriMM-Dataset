module adc_controller(  
    input clk,  
    input reset,  
    input start,  
    input [23:0] adc_input,  
    output reg [23:0] adc_output,  
    output reg valid  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            adc_output <= 24'b0;  
            valid <= 0;  
        end else if (start) begin  
            adc_output <= adc_input;  
            valid <= 1;  
        end  
    end  
endmodule