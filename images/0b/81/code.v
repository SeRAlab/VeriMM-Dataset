module mpc_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] current_state,
    input wire [3:0] input_signal,
    input wire control_signal,
    output reg [3:0] next_state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_state <= 4'b0000; // Reset state
        end else if (control_signal) begin
            next_state <= (current_state + input_signal) > 4'b1111 ? 4'b1111 : (current_state + input_signal);
        end else begin
            next_state <= current_state; // Hold current state
        end
    end
endmodule