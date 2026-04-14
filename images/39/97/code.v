module state_space_controller(
    input clk,
    input rst,
    input [1:0] control,
    output reg [2:0] state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000; // Reset state
        end else begin
            case (state)
                3'b000: state <= (control == 2'b00) ? 3'b001 : state;
                3'b001: state <= (control == 2'b00) ? 3'b010 : state;
                3'b010: state <= (control == 2'b00) ? 3'b011 : state;
                3'b011: state <= (control == 2'b00) ? 3'b100 : state;
                3'b100: state <= (control == 2'b00) ? 3'b000 : state;
                // Define other control transitions based on your specification
                default: state <= 3'b000; // Fallback to state 000
            endcase
        end
    end
endmodule