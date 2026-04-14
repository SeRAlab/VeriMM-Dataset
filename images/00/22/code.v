module DAC_16bit (  
    input [3:0] gain,  
    input [15:0] input_data,  
    output reg [19:0] output_signal  
);  
    always @(*) begin  
        case (gain)  
            4'b0000: output_signal = input_data * 1;  
            4'b0001: output_signal = input_data * 2;  
            4'b0010: output_signal = input_data * 4;  
            4'b0011: output_signal = input_data * 8;  
            4'b0100: output_signal = input_data * 16;  
            4'b0101: output_signal = input_data * 32;  
            default: output_signal = 20'b0;  
        endcase  
    end  
endmodule