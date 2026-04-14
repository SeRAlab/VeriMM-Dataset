module DAC_16bit (  
    input wire [15:0] digital_in,  
    input wire clk,  
    input wire enable,  
    output reg [15:0] analog_out  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            analog_out <= digital_in;  
        end  
    end  
endmodule