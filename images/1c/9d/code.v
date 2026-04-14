module echo_cancellation #(parameter SCALE = 8) (
    input clk,
    input rst,
    input signed [15:0] audio_in,
    input signed [15:0] echo_ref,
    output reg signed [15:0] audio_out
);
    
    reg signed [15:0] scaled_echo;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'd0;
        end else begin
            scaled_echo <= echo_ref >>> SCALE; // Right shift for scaling
            audio_out <= audio_in - scaled_echo; // Cancel out the echo
        end
    end
endmodule