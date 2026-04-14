module top_module(
    input clk,           // Added clk input
    input [3:0] B,
    output reg [3:0] E
);reg [3:0] B_reg;
reg [3:0] B_plus_3;

always @ (posedge clk) begin
    B_reg <= B;
    B_plus_3 <= B_reg + 4'b0011;
    E <= B_plus_3;  // Use non-blocking assignment directly to E
end

endmodule