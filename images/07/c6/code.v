module ADC_8bit(  
    input clk,  
    input reset,  
    input [2:0] channel_select,  
    output reg [7:0] digital_output  
);  

    reg [7:0] analog_inputs [7:0]; // 8 analog channel inputs  

    // Initialize analog inputs with sample values  
    initial begin  
        analog_inputs[0] = 8'd0;  
        analog_inputs[1] = 8'd64;  
        analog_inputs[2] = 8'd128;  
        analog_inputs[3] = 8'd192;  
        analog_inputs[4] = 8'd255;  
        analog_inputs[5] = 8'd32;  
        analog_inputs[6] = 8'd96;  
        analog_inputs[7] = 8'd224;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            digital_output <= 8'd0;  
        end else begin  
            digital_output <= analog_inputs[channel_select];  
        end  
    end  
endmodule