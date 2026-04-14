module zero_crossing_detector (
    input wire clk,
    input wire signal,
    output reg zero_cross
);
    reg previous_signal;

    always @(posedge clk) begin
        zero_cross <= 0; // Default output
        if ((previous_signal == 1'b0 && signal == 1'b1) || (previous_signal == 1'b1 && signal == 1'b0)) begin
            zero_cross <= 1; // Zero crossing detected
        end
        previous_signal <= signal;
    end
endmodule