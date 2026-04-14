module noise_suppression(
    input [4:0] signal_in,
    input clk,
    input reset,
    output reg [4:0] signal_out
);
    reg [4:0] previous_signal;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            signal_out <= 5'b0;
            previous_signal <= 5'b0;
        end else begin
            if (signal_in != previous_signal) begin
                // If a noise event is detected, hold the previous good value
                signal_out <= previous_signal;
            end else begin
                // If input is stable, update the output
                signal_out <= signal_in;
            end
            previous_signal <= signal_in;
        end
    end
endmodule