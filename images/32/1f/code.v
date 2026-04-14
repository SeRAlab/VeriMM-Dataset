module pitch_detection (
    input wire clk,
    input wire rst,
    input wire [7:0] signal_input,
    input wire [7:0] threshold,
    output reg pitch_detected
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pitch_detected <= 0;
        end else begin
            if (signal_input > threshold) begin
                pitch_detected <= 1;
            end else begin
                pitch_detected <= 0;
            end
        end
    end
endmodule