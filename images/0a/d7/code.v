module DAC_24bit (  
    input wire clk,  
    input wire reset,  
    input wire [23:0] digital_input,  
    output reg [23:0] analog_output  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            analog_output <= 24'b0;  
        else  
            analog_output <= digital_input;  
    end  
endmodule