module top_module(
    Index,
    Res,
    SignRes
);input [3:0] Index;
output [7:0] Res;
reg [7:0] Res;
output signed [7:0] SignRes;
reg signed [7:0] SignRes;

wire [7:0] RefS;
wire [7:0] Ref;

assign RefS = -8'd93;
assign Ref = 8'd93;


always @(Index, RefS, Ref) begin: BITSELECTDEMO_LOGIC
    Res[Index] = Ref[Index];
    SignRes[Index] = RefS[Index];
end

endmodule