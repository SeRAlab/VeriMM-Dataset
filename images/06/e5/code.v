module zero_crossing_detector(
    input wire clk,
    input wire signal,
    output reg crossing
);

    reg previous_signal;

    always @(posedge clk) begin
        if (previous_signal == 1 && signal == 0) begin
            crossing <= 1; // Positive to Negative
        end else if (previous_signal == 0 && signal == 1) begin
            crossing <= 0; // Negative to Positive
        end
        previous_signal <= signal;
    end
endmodule