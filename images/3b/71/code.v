module deadbeat_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] reference_input,
    input wire [7:0] current_state,
    output reg [7:0] control_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 8'd0;
        end else begin
            control_signal <= reference_input - current_state; // Deadbeat control law
        end
    end
endmodule