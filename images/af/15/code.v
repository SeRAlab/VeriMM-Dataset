module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);reg [7:0] prev_in;

always @(posedge clk) begin
    // Detect rising edges
    anyedge <= (in & ~prev_in);
    prev_in <= in;
end

always @(negedge clk) begin
    // Detect falling edges
    anyedge <= (prev_in & ~in);
end

endmodule