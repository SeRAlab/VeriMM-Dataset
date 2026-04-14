module deadbeat_controller (
    input clk,
    input reset,
    input [3:0] reference,
    input [3:0] current_state,
    output reg [3:0] control_output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_output <= 4'b0000;
        end else begin
            // Deadbeat control logic: control output is the difference
            // between reference input and current state
            control_output <= reference - current_state;
        end
    end
endmodule