module adc_controller(  
    input wire clk,  
    input wire reset,  
    input wire [23:0] adc_input,  
    output reg [11:0] upper_output,  
    output reg [11:0] lower_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            upper_output <= 12'b0;  
            lower_output <= 12'b0;  
        end else begin  
            upper_output <= adc_input[23:12];  
            lower_output <= adc_input[11:0];  
        end  
    end  
endmodule