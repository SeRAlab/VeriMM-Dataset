module current_sensor(
    input wire clk,
    input wire reset,
    input wire [7:0] current,  // 8-bit current input
    output reg warning          // warning output
);

    parameter THRESHOLD = 8'd100; // predefined threshold

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            warning <= 1'b0; // reset warning output
        end else if (current > THRESHOLD) begin
            warning <= 1'b1; // set warning if current exceeds threshold
        end else begin
            warning <= 1'b0; // clear warning if current is within limits
        end
    end
endmodule