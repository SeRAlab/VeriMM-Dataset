module top_module(
    input  [31:0] srcA,
    input  [31:0] srcB,
    input  [ 3:0] oper,
    input  [ 4:0] shift,
    output        sign,
    output reg [31:0] result
);always @ (*) begin
        case (oper)
            default     : result = srcA + srcB;
            4'h0        : result = srcA + srcB;
            4'h1        : result = srcA | srcB;
            4'h2        : result = srcA & srcB;
            4'h3        : result = (srcB << 16);
            4'h4        : result = srcB >> shift; 
            4'h6        : result = srcB >> srcA;
            4'h7        : result = (srcA < srcB) ? 1 : 0;
            4'h9        : result = srcA - srcB;
            4'hA        : result = ~(srcA | srcB);
            4'hB        : result = (srcB >= 0) ? 1 : 0;
        endcase
    end

    assign sign = (result == 0);
endmodule