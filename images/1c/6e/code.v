module adc_controller (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] adc_data,  
    input wire [15:0] threshold,  
    output reg adc_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            adc_out <= 0;  
        else if (adc_data >= threshold)  
            adc_out <= 1;  
        else  
            adc_out <= 0;  
    end  
endmodule