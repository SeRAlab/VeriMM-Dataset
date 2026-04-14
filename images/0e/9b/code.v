module audio_compressor(  
    input clk,  
    input reset,  
    input [15:0] audio_in,  
    output reg [7:0] audio_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            audio_out <= 8'b0;  
        end else begin  
            audio_out <= audio_in[15:8];  
        end  
    end  
endmodule