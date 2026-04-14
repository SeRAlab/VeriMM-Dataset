module audio_mixer(  
    input clk,  
    input [7:0] audio_in1,  
    input [7:0] audio_in2,  
    output reg [7:0] audio_out  
);  
    always @(posedge clk) begin  
        audio_out <= (audio_in1 + audio_in2) >> 1;  
    end  
endmodule