module audio_compressor(  
    input clk,  
    input reset,  
    input [4:0] audio_in,  
    output reg [4:0] audio_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            audio_out <= 5'b00000;  
        else  
            audio_out <= audio_in >> 1;  
    end  
endmodule