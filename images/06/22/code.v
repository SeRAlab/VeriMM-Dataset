module deadbeat_controller(
    input wire clk,
    input wire reset,
    input wire [3:0] desired_state,
    output reg [3:0] control_output
);
    reg [3:0] current_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 4'b0000;
            control_output <= 4'b0000;
        end else begin
            if (current_state != desired_state) begin
                control_output <= desired_state;  // Set output to desired state directly
                current_state <= desired_state;   // Update current state
            end
        end
    end
endmodule