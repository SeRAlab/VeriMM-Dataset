module audio_compressor(  
    input clk,  
    input [7:0] audio_in,  
    input [7:0] threshold,  
    output reg [7:0] audio_out  
);  
    always @(posedge clk) begin  
        if (audio_in > threshold)  
            audio_out <= audio_in >> 1;  
        else  
            audio_out <= audio_in;  
    end  
endmodule