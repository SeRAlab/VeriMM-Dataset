module twosComplement(
    input [3:0] iNum,
    output reg [3:0] oNum
);

always @(*) begin
    if(iNum[3] == 1) begin
        oNum = ~(iNum) + 1;
    end
    else begin
        oNum = iNum;
    end
end

endmodule