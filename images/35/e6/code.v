module DAC_24bit (  
    input [23:0] digital_input,  
    output reg [31:0] analog_output  
);  
    always @(*) begin  
        analog_output = {8'b0, digital_input};  
    end  
endmodule