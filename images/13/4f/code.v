module deadbeat_controller (
    input wire clk,
    input wire [2:0] current_state,
    output reg [2:0] next_state
);
    always @(posedge clk) begin
        case (current_state)
            3'b000: next_state <= 3'b001;
            3'b001: next_state <= 3'b010;
            3'b010: next_state <= 3'b011;
            3'b011: next_state <= 3'b100;
            3'b100: next_state <= 3'b000; // wraps around
            default: next_state <= 3'b000; // default case
        endcase
    end
endmodule