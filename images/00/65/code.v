module temp_shutdown (
    input clk,
    input reset,
    input [3:0] temp_reading,
    input [3:0] threshold,
    output reg shutdown_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown_signal <= 0;
        end else if (temp_reading > threshold) begin
            shutdown_signal <= 1;
        end else begin
            shutdown_signal <= 0;
        end
    end
endmodule