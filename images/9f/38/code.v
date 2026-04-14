module top_module( 
    input clk,                  // System clock
    input reset,                // Synchronous active-high reset
    input serial_in,            // Serial input for the shift register
    input [2:0] external_in,    // External 3-bit input for the adder
    output [3:0] shift_reg_out, // 4-bit output from the shift register
    output [2:0] adder_out,     // 3-bit output from the adder
    output [3:0] and_out        // 4-bit output from the AND module
);// Shift register module
    reg [3:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], serial_in};
        end
    end
    assign shift_reg_out = shift_reg;

    // Full adder module
    reg [3:0] adder_in;
    always @(posedge clk) begin
        if (reset) begin
            adder_in <= 3'b000;
        end else begin
            adder_in <= {shift_reg[3], shift_reg[2:0]} + external_in;
        end
    end
    assign adder_out = adder_in[2:0];

    // AND module
    assign and_out = shift_reg & adder_in;

endmodule