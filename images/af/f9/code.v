module top_module(
    input clk,                // Added clk input
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    output reg [7:0] max
);reg [7:0] max_temp1;
reg [7:0] max_temp2;
reg [7:0] max_temp3;

always @ (posedge clk) begin
    max_temp1 <= (A > B) ? A : B;
    max_temp2 <= (C > max_temp1) ? C : max_temp1;
    max_temp3 <= (D > max_temp2) ? D : max_temp2;
    max <= max_temp3;
end

endmodule