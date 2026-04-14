module top_module(
    input [3:0] in,
    input clk,                  // Added clk input
    output reg [3:0] out
);reg [7:0] sign_extended;
reg [7:0] twos_complement;

always @(*) begin
    sign_extended = { {4{in[3]}}, in }; // Corrected sign extension to 8 bits from 4 bits
end

always @(posedge clk) begin
    twos_complement <= ~sign_extended + 1;
end

assign out = twos_complement[3:0];

endmodule