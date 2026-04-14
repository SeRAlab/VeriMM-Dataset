module zero_crossing_detector (
    input wire clk,
    input wire reset,
    input wire signal,
    output reg [1:0] crossing_state // 00: no crossing, 01: rising edge, 10: falling edge
);

    reg previous_signal;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crossing_state <= 2'b00;
            previous_signal <= 1'b0;
        end else begin
            if (previous_signal == 1'b0 && signal == 1'b1) begin
                crossing_state <= 2'b01; // Rising edge
            end else if (previous_signal == 1'b1 && signal == 1'b0) begin
                crossing_state <= 2'b10; // Falling edge
            end else begin
                crossing_state <= 2'b00; // No crossing
            end
            previous_signal <= signal;
        end
    end
endmodule