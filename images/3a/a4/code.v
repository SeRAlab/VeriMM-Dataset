module pipeline_controller (
    input clk,
    input reset,
    input [2:0] instruction_type,
    output reg [6:0] control_signals // 7 control signals for 7 stages
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signals <= 7'b0000000; // Reset all control signals
        end else begin
            case (instruction_type)
                3'b000: control_signals <= 7'b0000001; // Example for instruction type 0
                3'b001: control_signals <= 7'b0000011; // Example for instruction type 1
                3'b010: control_signals <= 7'b0000111; // Example for instruction type 2
                3'b011: control_signals <= 7'b0001111; // Example for instruction type 3
                3'b100: control_signals <= 7'b0011111; // Example for instruction type 4
                3'b101: control_signals <= 7'b0111111; // Example for instruction type 5
                3'b110: control_signals <= 7'b1111111; // Example for instruction type 6
                default: control_signals <= 7'b0000000; // Default case
            endcase
        end
    end
endmodule