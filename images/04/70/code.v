module audio_codec_controller(  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [15:0] audio_sample,  
    output reg [15:0] encoded_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            encoded_output <= 16'b0;  
        end else if (enable) begin  
            encoded_output <= audio_sample << 1;  
        end  
    end  
endmodule