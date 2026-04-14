module top_module(
  input  wire          clk,
  input  wire          cpu_clk,
  input  wire          cpu_rst,
  input  wire [24-1:1] cpu_address,
  input  wire [24-1:1] cpu_address_in,
  input  wire          _cpu_as,
  input  wire          cpu_rd,
  input  wire          cpu_hwr,
  input  wire          cpu_lwr,
  input  wire [32-1:0] cpu_vbr,
  input  wire          dbr,
  input  wire          ovl,
  input  wire          freeze,
  output wire [16-1:0] cart_data_out,
  output reg           int7 = 1'b0,
  output wire          sel_cart,
  output wire          ovr,

  output wire          aron
);reg  [32-1:0] nmi_vec_adr;
reg           freeze_d = 1'b0;
wire          freeze_req;
wire          int7_req;
wire          int7_ack;
reg           l_int7_req = 1'b0;
reg           l_int7_ack = 1'b0;
reg           l_int7 = 1'b0;
reg           active = 1'b0;






assign aron = 1'b1;


assign sel_cart = ~dbr && (cpu_address_in[23:19]==5'b1010_0);


always @ (posedge clk) begin
  nmi_vec_adr <= #1 cpu_vbr + 32'h0000007c;
end



assign ovr = active && ~dbr && ~ovl && cpu_rd && (cpu_address_in[23:2] == nmi_vec_adr[23:2]);


assign cart_data_out = ovr ? (!cpu_address_in[1] ? 16'h00a0 : 16'h000c) : 16'h0000;


always @ (posedge clk) begin
  freeze_d <= freeze;
end

assign freeze_req = freeze && ~freeze_d;


assign int7_req =  freeze_req;



assign int7_ack = &cpu_address && ~_cpu_as;



always @ (posedge cpu_clk) begin
  if (cpu_rst)
    int7 <= 1'b0;
  else if (int7_req)
    int7 <= 1'b1;
  else if (int7_ack)
    int7 <= 1'b0;
end

always @ (posedge clk) begin
  l_int7_req <= int7_req;
  l_int7_ack <= int7_ack;
end

always @ (posedge clk) begin
  if (cpu_rst)
    l_int7 <= 1'b0;
  else if (l_int7_req)
    l_int7 <= 1'b1;
  else if (l_int7_ack && cpu_rd)
    l_int7 <= 1'b0;
end


always @ (posedge clk) begin
  if (cpu_rst)
    active <= #1 1'b0;
  else if ( l_int7 && l_int7_ack && cpu_rd)
    active <= #1 1'b1;
  else if (sel_cart && cpu_rd)
    active <= #1 1'b0;
end


endmodule