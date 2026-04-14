module edge_detector (
    input clk,
    input rst,
    input signal_in,
    output reg signal_out
);
    reg signal_in_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_out <= 0;
            signal_in_prev <= 0;
        end else begin
            signal_out <= (signal_in && !signal_in_prev);
            signal_in_prev <= signal_in;
        end
    end
endmodule