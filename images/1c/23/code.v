module pitch_detector (
    input wire clk,
    input wire reset,
    input wire [15:0] frequency,
    input wire [15:0] threshold,
    output reg is_above_threshold
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            is_above_threshold <= 0;
        end else begin
            if (frequency > threshold) begin
                is_above_threshold <= 1;
            end else begin
                is_above_threshold <= 0;
            end
        end
    end
endmodule