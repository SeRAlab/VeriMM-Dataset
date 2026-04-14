module PLL (
    input wire clk_in,
    input wire [1:0] control_voltage,
    output reg clk_out
);
    reg [1:0] divider;

    always @(posedge clk_in) begin
        divider <= control_voltage; // Update the divider based on control voltage
        case (divider)
            2'b00: clk_out <= 0; // No output
            2'b01: clk_out <= ~clk_out; // 1x frequency
            2'b10: clk_out <= ~clk_out; // 2x frequency
            2'b11: clk_out <= ~clk_out; // 3x frequency
            default: clk_out <= 0; // Default case
        endcase
    end
endmodule