module audio_level_controller(
    input [3:0] audio_in,
    input [1:0] volume_factor,
    output reg [3:0] audio_out
);
    
    always @(*) begin
        case (volume_factor)
            2'b00: audio_out = 4'b0000; // mute
            2'b01: audio_out = audio_in; // normal
            2'b10: audio_out = (audio_in << 1); // double
            2'b11: audio_out = (audio_in << 1) > 4'b1111 ? 4'b1111 : (audio_in << 1); // cap at 15
            default: audio_out = 4'b0000; // default case
        endcase
    end
endmodule