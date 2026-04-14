module edge_detector (
    input wire clk,
    input wire signal_in,
    output reg edge_out
);
    reg signal_in_prev;

    always @(posedge clk) begin
        edge_out <= 0; // Default output
        if (signal_in && !signal_in_prev) begin
            edge_out <= 1; // Rising edge detected
        end
        signal_in_prev <= signal_in; // Store the previous state
    end
endmodule