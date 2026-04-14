module echo_cancellation (
    input clk,
    input reset,
    input signed [15:0] audio_in,
    input signed [15:0] echo_in,
    output reg signed [15:0] audio_out
);
    reg signed [15:0] echo_buffer;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            audio_out <= 16'b0;
            echo_buffer <= 16'b0;
        end else begin
            echo_buffer <= echo_in; // Store the echo signal
            audio_out <= audio_in - echo_buffer; // Cancel the echo
        end
    end
endmodule