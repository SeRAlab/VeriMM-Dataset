module edge_detector(
    input wire clk,
    input wire signal_in,
    output reg edge_detected
);
    reg signal_in_prev;

    always @(posedge clk) begin
        edge_detected <= (signal_in && !signal_in_prev);
        signal_in_prev <= signal_in;
    end
endmodule