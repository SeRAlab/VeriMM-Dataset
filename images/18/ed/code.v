module dynamic_range_compressor (
    input wire clk,
    input wire reset,
    input wire [3:0] audio_in,
    output reg [3:0] audio_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            audio_out <= 4'b0000;
        end else begin
            if (audio_in >= 4'b1000) begin
                audio_out <= 4'b1000; // Output 8 for inputs >= 8
            end else begin
                audio_out <= audio_in >> 1; // Output input divided by 2
            end
        end
    end
endmodule