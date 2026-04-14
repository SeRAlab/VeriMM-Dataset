module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input [7:0] in,   // 8-bit input for the parity generator
    output [7:0] out  // 8-bit output from the system
);reg [3:0] count;
    wire parity;
    wire [3:0] counter_diff;
    
    // Parity generator
    assign parity = ^in;
    
    // Asynchronous reset for counter
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0;
        end else begin
            count <= count + 1;
        end
    end
    
    // Difference between counter and parity
    assign counter_diff = {4'b0, count} - {1'b0, parity};
    
    // Concatenate counter and difference
    assign out = {counter_diff, count};
    
endmodule