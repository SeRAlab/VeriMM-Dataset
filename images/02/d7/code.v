module VCO (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] voltage_input,  
    output reg [7:0] frequency_output  
);  
    parameter BASE_FREQUENCY = 8'd10; // Base frequency increment  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frequency_output <= 8'd0;  
        end else begin  
            frequency_output <= BASE_FREQUENCY * (voltage_input + 1);  
        end  
    end  
endmodule