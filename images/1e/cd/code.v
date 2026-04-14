module adc_controller (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] adc_input,  
    output reg [3:0] msb_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            msb_output <= 4'b0000;  
        end else begin  
            msb_output <= adc_input[15:12];  
        end  
    end  
endmodule