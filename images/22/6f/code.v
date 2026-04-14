module sample_rate_converter(
    input clk,
    input rst,
    input [15:0] audio_in,
    output reg [23:0] audio_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        audio_out <= 24'b0;
    end else begin
        audio_out <= {8'b0, audio_in}; // Zero-padding the lower 8 bits
    end
end

endmodule