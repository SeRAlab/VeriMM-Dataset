module butterworth_filter(  
    input [4:0] input_signal,  
    input clk,  
    output reg [4:0] output_signal  
);  
    // Coefficient values for a simple 2nd order Butterworth filter  
    parameter a1 = 5'b00011; // Example coefficient for the first stage  
    parameter a2 = 5'b00001; // Example coefficient for the second stage  
    reg [4:0] stage1_output;  
    reg [4:0] stage2_output;  

    always @(*) begin  
        stage1_output = (input_signal * a1) >> 2; // First stage processing  
        stage2_output = (stage1_output * a2) >> 2; // Second stage processing  
        output_signal = stage2_output; // Final output  
    end  
endmodule