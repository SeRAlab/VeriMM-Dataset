module audio_compressor (
    input wire clk,
    input wire rst,
    input wire [15:0] audio_in,
    output reg [15:0] audio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'b0;
        end else begin
            if (audio_in > 16'd2048) begin
                audio_out <= audio_in >> 1; // Divide by 2
            end else begin
                audio_out <= audio_in; // No change
            end
        end
    end
endmodule