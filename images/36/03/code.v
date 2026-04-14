module audio_mixer (
    input wire [7:0] audio_in1,
    input wire [7:0] audio_in2,
    input wire clk,
    input wire reset,
    output reg [7:0] audio_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            audio_out <= 8'b0;
        end else begin
            audio_out <= (audio_in1 + audio_in2) >> 1; // Average of two signals
        end
    end
endmodule