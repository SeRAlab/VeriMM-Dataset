module mpc_controller(
    input clk,
    input reset,
    input [3:0] desired_state,
    input [3:0] current_state,
    output reg [3:0] next_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state <= 4'b0000;
        end else begin
            if (desired_state > current_state) begin
                next_state <= current_state + 4'b0001; // Increment if desired_state is greater
            end else begin
                next_state <= current_state; // Hold current state
            end
        end
    end
endmodule