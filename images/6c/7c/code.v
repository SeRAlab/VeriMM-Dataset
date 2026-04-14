module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [3:0] counter_out,  // 4-bit output from the counter
    input [3:0] mux_out,  // 4-bit output from the multiplexer
    input select,     // Select input to choose between mux inputs
    output reg [7:0] out // 8-bit output from the functional module
);reg [7:0] sum; // Register to store the sum of the inputs

always @(posedge clk) begin
    if (reset) begin
        sum <= 8'b0; // Reset the sum to 0
    end else begin
        // Add the inputs and store the result in the sum register
        sum <= {4'b0, counter_out} + ({select, 1'b0} ? {4'b0, mux_out} : {4'b0, 4'b0});
    end
end

assign out = sum; // Assign the output to the sum register

endmodule