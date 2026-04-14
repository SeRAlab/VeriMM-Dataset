module deadbeat_controller (
    input clk,
    input reset,
    input [1:0] input_value,
    output reg [3:0] output_value
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_value <= 4'b0000;
        end else begin
            case(input_value)
                2'b00: output_value <= 4'b0000; // Target value is 0
                2'b01: output_value <= 4'b0001; // Target value is 1
                2'b10: output_value <= 4'b0010; // Target value is 2
                2'b11: output_value <= 4'b0011; // Target value is 3
                default: output_value <= 4'b0000; // Default case
            endcase
        end
    end
endmodule