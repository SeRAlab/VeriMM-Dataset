module current_sensor (
    input wire clk,
    input wire reset,
    input wire [7:0] current_input, // 8-bit current input
    output reg [7:0] current_value,  // 8-bit current value output
    output reg current_exceeds_threshold // Threshold exceed flag
);

parameter THRESHOLD = 8'd100; // Define threshold

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_value <= 8'd0;
        current_exceeds_threshold <= 1'b0;
    end else begin
        current_value <= current_input;
        if (current_input > THRESHOLD) begin
            current_exceeds_threshold <= 1'b1;
        end else begin
            current_exceeds_threshold <= 1'b0;
        end
    end
end

endmodule