module audio_mixer (  
    input clk,  
    input enable,  
    input [7:0] audio_in1,  
    input [7:0] audio_in2,  
    input [7:0] audio_in3,  
    input [7:0] audio_in4,  
    output reg [7:0] audio_out  
);  
    reg [7:0] avg;  
    always @(posedge clk) begin  
        if (enable) begin  
            avg = (audio_in1 + audio_in2 + audio_in3 + audio_in4) >> 2;  
            audio_out <= avg;  
        end  
    end  
endmodule