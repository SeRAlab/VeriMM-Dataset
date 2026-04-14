module top_module(
    ShiftVal,
    RSRes,
    LSRes
);input [3:0] ShiftVal;
output signed [7:0] RSRes;
wire signed [7:0] RSRes;
output signed [14:0] LSRes;
wire signed [14:0] LSRes;

wire [7:0] RefVal;

assign RefVal = -8'd55;



assign RSRes = $signed(RefVal >>> $signed({1'b0, ShiftVal}));
assign LSRes = (RefVal << $signed({1'b0, ShiftVal}));

endmodule