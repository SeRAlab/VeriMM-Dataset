module deadbeat_controller(
    input clk,
    input rst,
    input [3:0] desired_state,
    output reg [3:0] current_state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= 4'b0000;
        end else begin
            if (current_state != desired_state) begin
                current_state <= desired_state; // Deadbeat control: reach desired state immediately
            end
        end
    end
endmodule