module mpc_controller(
    input clk,
    input reset,
    input [3:0] control_input,
    output reg [3:0] state
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 4'b0000; // Reset state to 0
    end else begin
        state <= state + control_input; // Update state
    end
end

endmodule