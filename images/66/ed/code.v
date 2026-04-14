module traffic_light_controller (
    input clk,
    input [2:0] state,
    output reg [2:0] next_state,
    output reg green,
    output reg yellow,
    output reg red);

always @(posedge clk) begin
    case (state)
        3'b001: next_state = 3'b010; // Green to Yellow
        3'b010: next_state = 3'b100; // Yellow to Red
        3'b100: next_state = 3'b001; // Red to Green
        default: next_state = 3'b001; // Default to Green
    endcase
end

assign green = state[0];
assign yellow = state[1];
assign red = state[2];

endmodule