module zero_crossing_detector (
    input wire clk,
    input wire signal_in,
    output reg zero_cross
);
    reg signal_prev;

    always @(posedge clk) begin
        zero_cross <= (signal_prev < 0 && signal_in >= 0) ? 1 : 0;
        signal_prev <= signal_in;
    end
endmodule