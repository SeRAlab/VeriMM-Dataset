module audio_mixer(  
    input clk,  
    input reset,  
    input [7:0] audio_in1,  
    input [7:0] audio_in2,  
    output reg [7:0] audio_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            audio_out <= 8'b0;  
        end else begin  
            audio_out <= (audio_in1 + audio_in2) >> 1;  
        end  
    end  
endmodule