module data_forwarding (
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dest,
    output reg [1:0] forward
);

always @(*) begin
    if (src1 == dest) begin
        forward = 2'b01; // Forward from dest to src1
    end else if (src2 == dest) begin
        forward = 2'b10; // Forward from dest to src2
    end else begin
        forward = 2'b00; // No forwarding
    end
end

endmodule