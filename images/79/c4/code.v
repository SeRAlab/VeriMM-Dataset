module top_module(
    clk,
    reset_n,
    shift_by,
    datain,
    dataout
);parameter DATA_WIDTH = 8;
parameter REG_POST_RESET_HIGH = 0;

input clk;
input reset_n;
input [1:0] shift_by;
input [DATA_WIDTH-1:0] datain;
output [DATA_WIDTH-1:0] dataout;

reg [DATA_WIDTH-1:0] datain_r;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        if (REG_POST_RESET_HIGH == 1)
            datain_r <= {DATA_WIDTH{1'b1}};
        else
            datain_r <= {DATA_WIDTH{1'b0}};
    end else begin
        datain_r <= datain;
    end
end

wire [DATA_WIDTH-1:0] dataout_pre;

assign dataout_pre = (shift_by[0] == 1'b1) ? {datain[2*DATA_WIDTH-1:DATA_WIDTH], datain_r[2*DATA_WIDTH-1:DATA_WIDTH]} : {datain[DATA_WIDTH-1:0], datain[2*DATA_WIDTH-1:DATA_WIDTH]};

assign dataout = (shift_by[1] == 1'b1) ? {dataout_pre[DATA_WIDTH-1:0], dataout_pre[2*DATA_WIDTH-1:DATA_WIDTH]} : {dataout_pre[2*DATA_WIDTH-1:DATA_WIDTH], dataout_pre[DATA_WIDTH-1:0]};

endmodule