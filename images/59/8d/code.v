module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d_1,  // 8-bit input for the first data signal
    input [7:0] d_2,  // 8-bit input for the second data signal
    input select,     // Select signal for the multiplexer
    output [7:0] q    // 8-bit output from the register
);reg [7:0] mux_out;  // Output from the multiplexer
    reg [7:0] reg_out;  // Output from the register

    // 2-to-1 NAND-based multiplexer
    assign mux_out = ~(d_1 & select) & ~(d_2 & ~select);

    // 8-bit register with active high synchronous reset
    always @(negedge clk) begin
        if (reset) begin
            reg_out <= 8'h34;
        end else begin
            reg_out <= mux_out;
        end
    end

    // Output from the register
    assign q = reg_out;

endmodule