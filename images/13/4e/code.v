module edge_detector (
    input wire clk,
    input wire signal_in,
    output reg edge_detected
);
    reg signal_in_d;

    always @(posedge clk) begin
        signal_in_d <= signal_in; // Delay the input signal by one clock cycle
        edge_detected <= signal_in && ~signal_in_d; // Detect rising edge
    end
endmodule