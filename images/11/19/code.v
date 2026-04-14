module zero_crossing_detector (
    input wire clk,
    input wire rst,
    input wire signal,
    output reg zero_cross
);

reg prev_signal;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        zero_cross <= 0;
        prev_signal <= 0;
    end else begin
        if ((prev_signal == 1 && signal == 0) || (prev_signal == 0 && signal == 1)) begin
            zero_cross <= ~zero_cross; // Toggle output on zero crossing
        end
        prev_signal <= signal; // Store the current signal state
    end
end

endmodule