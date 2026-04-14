module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [3:0] mux_in1, // 4-bit input for first input of the multiplexer
    input [3:0] mux_in2, // 4-bit input for second input of the multiplexer
    input select, // 1-bit select input for the multiplexer
    output [3:0] out // 4-bit output from the XOR operation
);reg [3:0] count; // 4-bit binary counter
    wire [3:0] mux_out; // 4-bit output from the multiplexer

    // 4-bit binary counter
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end

    // 2-to-1 multiplexer
    assign mux_out = select ? mux_in2 : mux_in1;

    // XOR operation
    assign out = count ^ mux_out;

endmodule