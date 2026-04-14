module audio_mixer (
    input wire clk,
    input wire [7:0] audio_in1,
    input wire [7:0] audio_in2,
    input wire control,
    output reg [7:0] audio_out
);

always @(posedge clk) begin
    if (control) begin
        audio_out <= audio_in1 + audio_in2; // Sum the audio signals
    end else begin
        audio_out <= audio_in1; // Output the first audio signal
    end
end

endmodule