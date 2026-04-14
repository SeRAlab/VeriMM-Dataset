module adc_controller(  
    input wire clk,  
    input wire reset,  
    input wire [23:0] adc_input,  
    input wire [23:0] threshold,  
    output reg exceed_threshold  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            exceed_threshold <= 0;  
        else  
            exceed_threshold <= (adc_input > threshold) ? 1 : 0;  
    end  
endmodule