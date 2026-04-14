module audio_mixer (
    input wire clk,
    input wire select,
    input wire [15:0] audio_A,
    input wire [15:0] audio_B,
    output reg [15:0] audio_Y
);

always @(posedge clk) begin
    if (select == 0) begin
        audio_Y <= audio_A;
    end else begin
        audio_Y <= audio_B;
    end
end

endmodule