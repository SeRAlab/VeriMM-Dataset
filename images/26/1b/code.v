module edge_detector (
    input wire clk,
    input wire signal_in,
    output reg signal_out
);

reg signal_in_prev;

always @(posedge clk) begin
    signal_out <= (signal_in && !signal_in_prev);
    signal_in_prev <= signal_in;
end

endmodule