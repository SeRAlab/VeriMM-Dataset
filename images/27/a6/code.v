module edge_detector(
    input clk,
    input signal_in,
    output reg edge_detected
);
    reg last_signal_in;

    always @(posedge clk) begin
        if (signal_in && !last_signal_in) begin
            edge_detected <= 1'b1; // Rising edge detected
        end else begin
            edge_detected <= 1'b0; // No edge
        end
        last_signal_in <= signal_in; // Update the last signal state
    end
endmodule