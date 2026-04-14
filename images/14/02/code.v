module edge_detector (
    input wire clk,
    input wire signal_in,
    output reg edge_detected
);
    reg signal_in_prev;

    always @(posedge clk) begin
        edge_detected <= (signal_in == 1'b1 && signal_in_prev == 1'b0) ? 1'b1 : 1'b0;
        signal_in_prev <= signal_in;
    end
endmodule