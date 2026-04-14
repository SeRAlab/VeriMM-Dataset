module hazard_detection(
    input wire a,
    input wire b,
    output reg output_signal
);
    reg previous_output;

    always @(*) begin
        if (a && b) begin
            output_signal = 1;
            previous_output = output_signal;
        end else if (!a && !b) begin
            output_signal = 0;
            previous_output = output_signal;
        end else begin
            output_signal = previous_output; // Hold previous output during hazard
        end
    end
endmodule