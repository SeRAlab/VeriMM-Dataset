module audio_mixer(  
    input wire [7:0] audio_in1,  
    input wire [7:0] audio_in2,  
    input wire mix_select,  
    input wire rst,  
    output reg [7:0] audio_out  
);  
  
    always @(posedge rst or posedge mix_select) begin  
        if (rst) begin  
            audio_out <= 8'b0;  
        end else if (mix_select) begin  
            audio_out <= audio_in2;  
        end else begin  
            audio_out <= audio_in1;  
        end  
    end  
endmodule