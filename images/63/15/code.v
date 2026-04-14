module top_module(
    input clk, 
    input rst_n,

    input             valid_i,
    input      [63:0] mv_i,
    output reg        valid_o,
    output     [ 5:0] mv_addr_o,
    output     [ 7:0] mv_o
);reg  [63:0] buffer;
wire [63:0] n_buffer;

reg  [2:0] mv_row, mv_col;
wire [2:0] n_mv_row, n_mv_col;
wire       n_valid_o;

assign mv_addr_o = {mv_row, mv_col};
assign mv_o      = buffer[7:0];

assign n_valid_o = valid_o        ? mv_col != 3'd7 : valid_i;
assign n_buffer  = valid_o        ? {8'b0, buffer[63:8]} : mv_i;
assign n_mv_col  = valid_o        ? mv_col + 3'd1 : 3'd0;
assign n_mv_row  = mv_col != 3'd7 ? mv_row :
                   mv_row == 3'd5 ? 3'd0 : mv_row + 3'd1;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        valid_o <=  1'b0;
        buffer  <= 64'd0;
        mv_row  <=  3'd0;
        mv_col  <=  3'd0;
    end else begin
        valid_o <= n_valid_o;
        buffer  <= n_buffer;
        mv_row  <= n_mv_row;
        mv_col  <= n_mv_col;
    end
end
endmodule