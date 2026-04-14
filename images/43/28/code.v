module top_module(srcA, srcB, result);input [31:0] srcA;
    input [31:0] srcB;

    output [31:0] result;
    

    

    wire [31:0] expA = {24'b0, srcA[30:23]};
    wire [31:0] expB = {24'b0, srcB[30:23]};

    wire [31:0] manA = {8'b0, 1'b1, srcA[22:0]};
    wire [31:0] manB = {8'b0, 1'b1, srcB[22:0]};

    wire [31:0] diff = expA - expB;
    wire [31:0] expR = diff > 0 ? expA : expB;

    wire [31:0] manMin;
    wire [31:0] manMax;

    assign {manMin, manMax} = diff > 0 ? {manB, manA} : {manA, manB};

    wire [31:0] manMinShift = manMin >> diff;

    wire [31:0] sum = manMax + manMinShift;
    wire [31:0] _sum = sum[31:24] != 0 ? sum >> 1 : sum;
    wire [31:0] expRshift = sum[31:24] != 0 ? expR + 1 : expR;

    assign result = {1'b0, expRshift[7:0], _sum[22:0]};

endmodule