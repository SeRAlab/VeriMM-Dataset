module mpc_controller (
    input clk,
    input rst,
    input [7:0] ref_input,
    output reg [7:0] control_signal
);
    reg [7:0] current_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= 8'b0;
            control_signal <= 8'b0;
        end else begin
            current_state <= control_signal; // Update current state
            control_signal <= ref_input - current_state; // Proportional control
        end
    end
endmodule