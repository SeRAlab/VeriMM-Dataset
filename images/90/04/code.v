module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [255:0] in, // Input for the 256-to-1 multiplexer
    input [7:0] sel,  // Selection signal for the 256-to-1 multiplexer
    output [3:0] q,   // Output from the 4-bit binary counter
    output [3:0] out  // Final output from the functional module
);// 256-to-1 multiplexer
    wire [7:0] mux_sel;
    assign mux_sel = sel;
    wire [7:0] mux_out;
    assign mux_out = in[mux_sel];

    // 4-bit binary counter
    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1;
        end
    end
    assign q = counter;

    // Functional module
    assign out = mux_out & q;

endmodule