module top_module(
    input clk,
    input rst,
    input [3:0] pin_name,
    input pin_dir,
    input pin_state,
    output reg [19:0] pin_states
);always @(posedge clk) begin
    if (rst) begin
        pin_states <= 0;
    end else begin
        if (pin_dir == 1'b0) begin
            // Input pin
            pin_states[pin_name] <= 1'bZ; // High-impedance state
        end else begin
            // Output pin
            pin_states[pin_name] <= pin_state;
        end
    end
end

assign pin_state_out = pin_states[pin_name];

endmodule