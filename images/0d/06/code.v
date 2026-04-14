module zero_crossing_detector(
    input wire clk,
    input wire reset,
    input wire signal,
    output reg crossing
);
reg previous_signal;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        previous_signal <= 0;
        crossing <= 0;
    end else begin
        crossing <= (previous_signal && !signal) || (!previous_signal && signal);
        previous_signal <= signal;
    end
end
endmodule