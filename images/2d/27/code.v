module audio_mixer(  
    input clk,  
    input enable,  
    input [7:0] audio_in1,  
    input [7:0] audio_in2,  
    output reg [7:0] audio_out  
);  

always @(posedge clk) begin  
    if (enable)  
        audio_out <= (audio_in1 + audio_in2) >> 1; // Average of two input signals  
    else  
        audio_out <= 8'b00000000; // Output zero when not enabled  
end  
endmodule