module top_module(
    input [3:0] in,
    output reg [3:0] out,  // Change 'wire' to 'reg' to allow assignment in the always block
    input clk
);always @(posedge clk) begin
        out <= in + 4'b0101;  // Assigning to 'out' in a procedural block
    end

endmodule