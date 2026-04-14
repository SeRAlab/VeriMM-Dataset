module top_module(
    input [1:0] current_state,
    input pedestrian_button,
    output reg [1:0] next_state // Change output to reg type
);always @(*) begin
        case (current_state)
            2'b00: begin // green
                if (pedestrian_button) begin
                    next_state = 2'b01; // yellow
                end else begin
                    next_state = 2'b10; // red
                end
            end
            2'b01: begin // yellow
                next_state = 2'b10; // red
            end
            2'b10: begin // red
                next_state = 2'b00; // green
            end
            default: begin
                next_state = 2'b00; // default to green
            end
        endcase
    end

endmodule