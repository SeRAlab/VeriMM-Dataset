module priority_arbiter(
    input [3:0] req,
    output reg [3:0] grant
);

always @(*) begin
    grant = 4'b0000; // Default: no grants
    if (req[3]) grant = 4'b1000; // Grant req[3]
    else if (req[2]) grant = 4'b0100; // Grant req[2]
    else if (req[1]) grant = 4'b0010; // Grant req[1]
    else if (req[0]) grant = 4'b0001; // Grant req[0]
end

endmodule