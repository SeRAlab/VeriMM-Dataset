module kalman_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] measurement,
    input wire [15:0] predicted_state,
    input wire [15:0] kalman_gain,
    output reg [15:0] updated_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            updated_state <= 16'b0;
        end else begin
            updated_state <= predicted_state + (kalman_gain * (measurement - predicted_state));
        end
    end
endmodule