module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);reg [7:0] prev_in;

always @(posedge clk) begin
    // Shift in the current input values
    prev_in <= in;
    
    // Detect any edge and set corresponding anyedge bit to 1
    anyedge <= (in ^ prev_in) & in;
end

endmodule