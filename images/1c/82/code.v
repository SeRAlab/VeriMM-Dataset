module audio_compressor (  
    input clk,  
    input reset,  
    input [15:0] audio_sample_in,  
    output reg [7:0] compressed_sample_out  
);  
  
    reg [15:0] last_sample;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            compressed_sample_out <= 8'b0;  
            last_sample <= 16'b0;  
        end else begin  
            last_sample <= audio_sample_in;  
            compressed_sample_out <= audio_sample_in[15:8]; // Keep the most significant byte  
        end  
    end  
endmodule