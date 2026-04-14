module state_space_controller (
    input clk,
    input reset,
    input [7:0] x1, // state variable x1
    input [7:0] x2, // state variable x2
    output reg [7:0] u  // control input
);
    // State feedback gain
    parameter K1 = 8'd2;
    parameter K2 = 8'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            u <= 8'd0; // Reset control input
        end else begin
            // u = -K1*x1 - K2*x2
            u <= -(K1 * x1 + K2 * x2);
        end
    end
endmodule