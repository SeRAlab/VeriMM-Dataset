module audio_mixer (
    input wire clk,
    input wire [15:0] audio_A,
    input wire [15:0] audio_B,
    input wire select,
    output reg [15:0] output_audio
);
    
    always @(posedge clk) begin
        if (select)
            output_audio <= audio_B;
        else
            output_audio <= audio_A;
    end
endmodule