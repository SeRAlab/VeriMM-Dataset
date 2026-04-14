module deadbeat_controller(
    input clk,
    input [3:0] current_state,
    input [3:0] desired_state,
    output reg [3:0] control_signal
);
    always @(posedge clk) begin
        control_signal <= desired_state ^ current_state; // XOR to find bits that need to change
    end
endmodule