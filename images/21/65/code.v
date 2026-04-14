module zero_crossing_detector (
    input clk,             // Clock signal
    input rst,             // Reset signal
    input wire signal_in,  // Input signal
    output reg crossing     // Crossing output signal
);

reg previous_signal;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        crossing <= 0;
        previous_signal <= 0;
    end else begin
        if ((previous_signal == 1 && signal_in == 0) || (previous_signal == 0 && signal_in == 1)) begin
            crossing <= ~crossing; // Toggle crossing output
        end
        previous_signal <= signal_in; // Update previous signal
    end
end

endmodule