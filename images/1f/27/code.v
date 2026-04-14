module iir_filter #(parameter B0 = 16'h1, B1 = 16'h1, B2 = 16'h1, A1 = 16'h1, A2 = 16'h1) (  
    input clk,  
    input rst,  
    input [15:0] input_sample,  
    output reg [15:0] output_sample  
);  
    reg [15:0] input_delay1;  
    reg [15:0] input_delay2;  
    reg [15:0] output_delay1;  
    reg [15:0] output_delay2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_sample <= 16'b0;  
            input_delay1 <= 16'b0;  
            input_delay2 <= 16'b0;  
            output_delay1 <= 16'b0;  
            output_delay2 <= 16'b0;  
        end else begin  
            output_sample <= (B0 * input_sample + B1 * input_delay1 + B2 * input_delay2 - A1 * output_delay1 - A2 * output_delay2) >> 15;  
            input_delay2 <= input_delay1;  
            input_delay1 <= input_sample;  
            output_delay2 <= output_delay1;  
            output_delay1 <= output_sample;  
        end  
    end  
endmodule