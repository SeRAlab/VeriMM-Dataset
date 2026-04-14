module zero_crossing_detector(
    input wire clk,
    input wire signal,
    output reg crossing
);

reg previous_signal;

always @(posedge clk) begin
    crossing <= (previous_signal == 1'b0 && signal == 1'b1) || (previous_signal == 1'b1 && signal == 1'b0);
    previous_signal <= signal;
end

endmodule