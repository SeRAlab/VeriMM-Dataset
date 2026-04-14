module top_module(
    Res,
    ResS
);output [6:0] Res;
wire [6:0] Res;
output signed [6:0] ResS;
wire signed [6:0] ResS;

wire [5:0] RefVal;

assign RefVal = 6'd25;



assign Res = {1'b1, RefVal};
assign ResS = $signed({1'b1, RefVal});

endmodule