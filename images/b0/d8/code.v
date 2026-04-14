module top_module(
    input [7:0] a,
    input [7:0] b,
    input clk,
    output reg [15:0] result
);reg [7:0] multiplier;
reg [15:0] multiplicand;
integer i;  // Declare i as an integer

always @(*) begin
    multiplier = b;
    multiplicand = {8'b0, a};
    result = 16'b0;  // Initialize result
end

always @(posedge clk) begin
    result = 16'b0;  // Initialize result on positive clock edge
    for (i = 0; i < 8; i = i + 1) begin
        if (multiplier[i] == 1'b1) begin
            result = result + (multiplicand << i);
        end
    end
end

endmodule