module top_module(
    input clk,
    input reset,
    input signal_in,
    output reg rising_edge,
    output reg falling_edge);reg signal_in_d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            signal_in_d <= 0;
            rising_edge <= 0;
            falling_edge <= 0;
        end else begin
            rising_edge <= (signal_in && !signal_in_d);
            falling_edge <= (!signal_in && signal_in_d);
            signal_in_d <= signal_in;
        end
    end

endmodule