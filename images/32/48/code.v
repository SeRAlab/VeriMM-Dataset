module mpc_controller (
    input clk,
    input reset,
    input [3:0] state,
    output reg [3:0] control_action
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_action <= 4'b0000;
        end else begin
            if (state > 4'b1000) begin
                control_action <= 4'b1111; // Maximum control action
            end else begin
                control_action <= state + 1; // Feedback control
            end
        end
    end
endmodule