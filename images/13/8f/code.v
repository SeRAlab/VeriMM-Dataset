module audio_mixer (
    input wire [7:0] audio1,
    input wire [7:0] audio2,
    input wire control,
    output reg [7:0] output_audio
);
    always @(*) begin
        if (control) begin
            output_audio = audio1 + audio2;
            if (output_audio > 8'd255)
                output_audio = 8'd255;
        end else begin
            output_audio = audio1;
        end
    end
endmodule