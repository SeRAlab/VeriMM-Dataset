module portfolio_optimizer (
    input [7:0] stock1,
    input [7:0] stock2,
    input [7:0] stock3,
    input [7:0] stock4,
    input [7:0] stock5,
    output reg [7:0] max_return
);

always @(*) begin
    max_return = stock1; // Initialize with the first stock
    if (stock2 > max_return) max_return = stock2;
    if (stock3 > max_return) max_return = stock3;
    if (stock4 > max_return) max_return = stock4;
    if (stock5 > max_return) max_return = stock5;
end

endmodule