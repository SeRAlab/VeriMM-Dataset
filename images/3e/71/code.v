module ADC_Controller(  
    input wire clk,  
    input wire enable,  
    input wire [9:0] analog_input,  
    output reg [7:0] digital_output  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            digital_output <= analog_input[7:0];  
        end else begin  
            digital_output <= 8'b0;  
        end  
    end  
endmodule