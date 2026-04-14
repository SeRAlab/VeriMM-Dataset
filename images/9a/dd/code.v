module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] d, // 8-bit input for the register
    input sel_b1, // Select input for 2-to-1 multiplexer
    input sel_b2, // Select input for 2-to-1 multiplexer
    input a, // Input signal a for 2-to-1 multiplexer
    input b, // Input signal b for 2-to-1 multiplexer
    output [7:0] q // 8-bit output from the final functional module
);// Define the 8-bit register with synchronous reset
reg [7:0] reg_q;
always @(posedge clk) begin
    if (reset) begin
        reg_q <= 8'h34;
    end else begin
        reg_q <= d;
    end
end

// Define the 2-to-1 multiplexer
wire [7:0] mux_out;
assign mux_out = (sel_b1 & sel_b2) ? b : a;

// Define the functional module that performs OR operation
wire [7:0] or_out;
assign or_out = reg_q | mux_out;

// Define the final output
assign q = or_out;

endmodule