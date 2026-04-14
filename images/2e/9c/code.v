module pitch_detector(
    input wire clk,
    input wire reset,
    input wire [3:0] audio_signal,
    input wire [3:0] threshold,
    output reg pitch_high
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pitch_high <= 1'b0;
        end else begin
            if (audio_signal > threshold) begin
                pitch_high <= 1'b1;
            end else begin
                pitch_high <= 1'b0;
            end
        end
    end
endmodule