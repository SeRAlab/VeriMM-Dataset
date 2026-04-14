module edge_detector (
    input wire clk,
    input wire rst,
    input wire signal,
    output reg pulse
);
    reg signal_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_prev <= 0;
            pulse <= 0;
        end else begin
            if (signal && !signal_prev) begin
                pulse <= 1; // Rising edge detected
            end else begin
                pulse <= 0; // Reset pulse
            end
            signal_prev <= signal; // Store current signal
        end
    end
endmodule