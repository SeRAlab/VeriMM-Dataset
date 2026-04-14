module audio_gain_control(  
    input [15:0] audio_in,  
    input [1:0] gain_ctrl,  
    output reg [15:0] audio_out  
);  
    always @(*) begin  
        case (gain_ctrl)  
            2'b00: audio_out = audio_in;          // No gain  
            2'b01: audio_out = audio_in << 1;     // x2 gain  
            2'b10: audio_out = audio_in << 2;     // x4 gain  
            2'b11: audio_out = audio_in << 3;     // x8 gain  
            default: audio_out = audio_in;  
        endcase  
    end  
endmodule