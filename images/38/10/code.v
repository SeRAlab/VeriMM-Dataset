module audio_compressor(  
    input wire clk,  
    input wire rst,  
    input wire [15:0] audio_in,  
    output reg [7:0] audio_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            audio_out <= 8'b0;  
        end else begin  
            audio_out <= audio_in[15:8];  
        end  
    end  
endmodule