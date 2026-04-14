module adc_controller(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] adc_input,  
    output reg [7:0] adc_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            adc_output <= 8'b0;  
        end else begin  
            adc_output <= adc_input[15:8];  
        end  
    end  
endmodule