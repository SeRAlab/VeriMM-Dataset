module data_forwarding_unit(
    input [3:0] src1,
    input [3:0] src2,
    input [3:0] dest,
    input valid,
    output reg forwardA,
    output reg forwardB
);
    
always @(*) begin
    forwardA = 0;
    forwardB = 0;
    if (valid) begin
        if (src1 == dest) begin
            forwardA = 1;
        end
        if (src2 == dest) begin
            forwardB = 1;
        end
    end
end

endmodule