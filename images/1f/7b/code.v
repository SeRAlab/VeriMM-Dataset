module dynamic_range_compressor(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] audio_in,  
    output reg [15:0] audio_out  
);  
    parameter THRESHOLD = 16'h8000;  
    parameter RATIO = 16'h4000; // Compression ratio  
 
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            audio_out <= 16'h0000;  
        end else begin  
            if (audio_in > THRESHOLD) begin  
                audio_out <= (audio_in - THRESHOLD) * RATIO / 16'h4000 + THRESHOLD;  
            end else begin  
                audio_out <= audio_in;  
            end  
        end  
    end  
endmodule