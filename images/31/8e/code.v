module data_forwarding_unit (
    input [4:0] src1, // source register 1 from current instruction
    input [4:0] src2, // source register 2 from current instruction
    input [4:0] dest1, // destination register from previous instruction
    input [4:0] dest2, // another destination register from previous instruction
    output reg forwardA, // forwarding signal for src1
    output reg forwardB  // forwarding signal for src2
);

always @(*) begin
    forwardA = (src1 == dest1) ? 1'b1 : (src1 == dest2) ? 1'b1 : 1'b0;
    forwardB = (src2 == dest1) ? 1'b1 : (src2 == dest2) ? 1'b1 : 1'b0;
end
endmodule