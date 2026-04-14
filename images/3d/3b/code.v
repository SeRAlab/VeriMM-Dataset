module edge_detector (
    input wire clk,
    input wire reset,
    input wire signal_in,
    output reg signal_out
);
    reg signal_in_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            signal_out <= 0;
            signal_in_prev <= 0;
        end else begin
            if (signal_in & ~signal_in_prev) begin
                signal_out <= 1; // Detect rising edge
            end else begin
                signal_out <= 0; // Reset output after one clock cycle
            end
            signal_in_prev <= signal_in; // Store current input for next edge detection
        end
    end
endmodule