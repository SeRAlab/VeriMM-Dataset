module EchoCancellation (
    input clk,
    input rst,
    input [15:0] audio_in,
    input [15:0] echo_in,
    output reg [15:0] audio_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        audio_out <= 16'b0;
    end else begin
        audio_out <= audio_in - echo_in; // Echo cancellation
    end
end

endmodule