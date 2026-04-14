module audio_mixer (
    input [7:0] audio_in1,
    input [7:0] audio_in2,
    input [7:0] volume1,
    input [7:0] volume2,
    output reg [7:0] audio_out,
    input clk,
    input rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 8'b0;
        end else begin
            // Calculate mixed output
            audio_out <= (audio_in1 * volume1 / 255) + (audio_in2 * volume2 / 255);
            // Clamp output to maximum value of 255
            if (audio_out > 8'hFF) begin
                audio_out <= 8'hFF;
            end
        end
    end
endmodule