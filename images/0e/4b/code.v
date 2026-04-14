module zero_crossing_detector (
    input clk,
    input rst,
    input signal_in,
    output reg zero_crossed
);
    
    reg signal_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            zero_crossed <= 0;
            signal_prev <= 0;
        end else begin
            zero_crossed <= (signal_in && !signal_prev) || (!signal_in && signal_prev);
            signal_prev <= signal_in;
        end
    end
endmodule