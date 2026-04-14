module top_module(
    input clk,
    input [31:0] addr1,
    input [31:0] addr2,
    input [31:0] req1,
    input [31:0] req2,
    input [31:0] res1,
    input [31:0] res2,
    output [31:0] reqA,
    output [31:0] reqB,
    output [31:0] resA,
    output [31:0] resB
);reg [31:0] reqA_reg, reqB_reg, resA_reg, resB_reg;

always @(posedge clk) begin
    // Route req1 and res1 to reqA/resA if addr1[2] is 0
    if (addr1[2] == 0) begin
        reqA_reg <= req1;
        resA_reg <= res1;
    end else begin
        reqB_reg <= req1;
        resB_reg <= res1;
    end

    // Route req2 and res2 to reqA/resA if addr2[2] is 0
    if (addr2[2] == 0) begin
        reqA_reg <= req2;
        resA_reg <= res2;
    end else begin
        reqB_reg <= req2;
        resB_reg <= res2;
    end
end

assign reqA = (addr1[2] == 0) ? req1 : req2;
assign reqB = (addr1[2] == 0) ? req2 : req1;
assign resA = (addr1[2] == 0) ? res1 : res2;
assign resB = (addr1[2] == 0) ? res2 : res1;
assign reqA = (resA_reg[31] == 1) ? resA_reg : 32'h80000000;
assign reqB = (resB_reg[31] == 1) ? resB_reg : 32'h80000000;
assign resA = (resA_reg[31] == 1) ? 32'h80000000 : resA_reg;
assign resB = (resB_reg[31] == 1) ? 32'h80000000 : resB_reg;

endmodule