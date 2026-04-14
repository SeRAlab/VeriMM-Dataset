module data_forwarding(
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dest,
    output reg [1:0] forward
);
    always @(*) begin
        if (src1 == dest)
            forward = 2'b01; // Forward from src1
        else if (src2 == dest)
            forward = 2'b10; // Forward from src2
        else
            forward = 2'b00; // No forwarding
    end
endmodule