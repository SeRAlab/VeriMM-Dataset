module audio_mixer (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] audio_in1,  
    input wire [7:0] audio_in2,  
    output reg [7:0] audio_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        audio_out <= 8'b0;  
    else  
        audio_out <= (audio_in1 + audio_in2) >> 1;  
end  
endmodule