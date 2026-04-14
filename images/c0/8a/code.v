module wb_slv_wrapper (
  input         rst_i,clk_i,
  input         stb_i,we_i,
  output        ack_o,
  input  [31:0] adr_i,  
  input  [31:0] dat_i,
  output [31:0] dat_o,
  output        rst,clk,
  output        wr_out,rd_out,
  output [ 7:0] addr_out,  
  output [31:0] data_out,
  input  [31:0] data_in
);
reg  stb_i_d1;
wire stb_internal = stb_i && !stb_i_d1;
reg  ack_internal;
always @(posedge rst_i or posedge clk_i) begin
  if (rst_i)
    stb_i_d1 <= 1'b0;
  else if (ack_internal)
    stb_i_d1 <= 1'b0;
  else
    stb_i_d1 <= stb_i;
end
assign {rst, clk}     = {rst_i, clk_i};
assign wr_out         = stb_internal &&  we_i;
assign rd_out         = stb_internal && !we_i;
assign addr_out[ 7:0] = adr_i[ 7:0];
assign data_out[31:0] = dat_i[31:0];
always @(posedge rst_i or posedge clk_i) begin
  if (rst_i)
    ack_internal <= 1'b0;
  else if (ack_internal)
    ack_internal <= 1'b0;
  else if (stb_i)
    ack_internal <= 1'b1;
  else
    ack_internal <= ack_internal;
end
assign ack_o       = ack_internal;
assign dat_o[31:0] = data_in[31:0];
endmodule