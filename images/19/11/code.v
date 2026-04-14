module deadbeat_controller (
    input [3:0] current_state,
    output reg [3:0] control_action,
    input clk,
    input rst
);
    // Desired state to achieve
    localparam DESIRED_STATE = 4'b1010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_action <= 4'b0000; // Reset control action
        end else begin
            control_action <= DESIRED_STATE - current_state; // Calculate control action
        end
    end
endmodule