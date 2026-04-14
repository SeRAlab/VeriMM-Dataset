module data_forwarding_unit (
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dest,
    output reg forward1,
    output reg forward2
);
    always @(*) begin
        forward1 = (src1 == dest) ? 1'b1 : 1'b0;
        forward2 = (src2 == dest) ? 1'b1 : 1'b0;
    end
endmodule