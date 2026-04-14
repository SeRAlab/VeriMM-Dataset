module top_module(
    input iClock,
    input iReset,
    input [31:0] iInstruction,
    output reg [31:0] oIP,
    output reg [31:0] oA,
    output reg [31:0] oB,
    output reg oJump,
    output reg [31:0] oNextIP
);reg [31:0] S;
reg [31:0] D;
reg [31:0] B;
reg [31:0] sub;
reg leq;

always @(posedge iClock) begin
    if (iReset) begin
        oIP <= 32'd0;
        oA <= 32'd0;
        oB <= 32'd0;
        oJump <= 1'b0;
        oNextIP <= 32'd0;
    end else begin
        // fetch instruction
        S <= iInstruction[23:16];
        D <= iInstruction[15:8];
        B <= iInstruction[7:0];
        
        // execute subleq instruction
        sub <= D - S;
        leq <= sub[31] || sub == 32'b0;
        oJump <= leq;
        oNextIP <= leq ? B : oIP + 32'd4;
        oA <= D - S;
        oB <= B;
        oIP <= oJump ? B : oIP + 32'd4;
    end
end

endmodule