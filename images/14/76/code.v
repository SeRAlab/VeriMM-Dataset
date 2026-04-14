module vco (
    input wire clk,
    input wire [1:0] control_voltage,
    output reg [3:0] vco_output
);
    always @(posedge clk) begin
        case (control_voltage)
            2'b00: vco_output <= vco_output; // Lowest frequency, output holds state
            2'b01: vco_output <= ~vco_output; // Medium frequency, toggle on each clock cycle
            2'b10: vco_output <= {vco_output[2:0], ~vco_output[3]}; // Higher frequency, shift and toggle
            2'b11: vco_output <= {~vco_output[3], vco_output[2:0]}; // Highest frequency, rotate and toggle
            default: vco_output <= 4'b0000; // Default case
        endcase
    end
endmodule