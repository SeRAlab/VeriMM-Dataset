module state_space_controller(
    input clk,
    input rst,
    input control_input,
    input [2:0] state_in,
    output reg [2:0] state_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            state_out <= 3'b000; // Reset to State 0
        else begin
            case (state_in)
                3'b000: state_out <= control_input ? 3'b001 : 3'b000; // State 0
                3'b001: state_out <= control_input ? 3'b001 : 3'b010; // State 1
                3'b010: state_out <= control_input ? 3'b001 : 3'b000; // State 2
                3'b011: state_out <= control_input ? 3'b011 : 3'b010; // State 3
                3'b100: state_out <= control_input ? 3'b011 : 3'b100; // State 4
                3'b101: state_out <= control_input ? 3'b101 : 3'b100; // State 5
                3'b110: state_out <= control_input ? 3'b000 : 3'b101; // State 6
                3'b111: state_out <= control_input ? 3'b111 : 3'b110; // State 7
                default: state_out <= 3'b000; // Default case
            endcase
        end
    end
endmodule