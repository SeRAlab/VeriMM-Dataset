module pitch_detector (
    input wire clk,
    input wire reset,
    input wire [9:0] frequency, // Assume frequency is represented in Hz
    output reg in_range
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            in_range <= 0;
        end else begin
            if (frequency >= 440 && frequency <= 450) begin
                in_range <= 1; // In range
            end else begin
                in_range <= 0; // Out of range
            end
        end
    end
endmodule