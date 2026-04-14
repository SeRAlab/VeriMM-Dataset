module mux_2to1 (
    input [3:0] audio_in0,   // First audio input
    input [3:0] audio_in1,   // Second audio input
    input select,            // Select line
    output reg [3:0] audio_out // Output audio signal
);

always @(*) begin
    if (select)
        audio_out = audio_in1; // Select second audio input
    else
        audio_out = audio_in0; // Select first audio input
end

endmodule