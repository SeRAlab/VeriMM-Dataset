module audio_compressor (
    input wire clk,
    input wire reset,
    input wire [15:0] audio_in,
    output reg [15:0] audio_out
);
    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
            audio_out <= 16'b0;
        end else begin
            if (count == 2'b00) begin
                audio_out <= audio_in;  // Capture audio input on the first clock cycle
            end
            count <= count + 1;  // Increment count
            if (count == 2'b11) begin
                count <= 2'b00;  // Reset count after 4 cycles (effectively taking every second sample)
            end
        end
    end
endmodule