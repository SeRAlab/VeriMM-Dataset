module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [3:0] d,    // 4-bit input for the shift register and adder
    output [3:0] out   // 4-bit output from the active module
);reg [3:0] reg_out;
    wire [3:0] add_out;
    wire active;

    // 4-bit shift register with active high synchronous reset to 0
    always @(posedge clk) begin
        if (reset) begin
            reg_out <= 4'b0;
        end else begin
            reg_out <= {d[2:0], d[3]};
        end
    end

    // 4-bit adder that adds the value of the register with the input data
    assign add_out = reg_out + d;

    // Functional module that performs an AND operation on the MSBs of the register and adder outputs
    assign active = (reg_out[3] & add_out[3]);

    // Output the value of the active module
    assign out = (active) ? add_out : reg_out;

endmodule