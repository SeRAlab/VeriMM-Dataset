module top_module(A0,A1,A2,A3,WCLK,WE,D,O);input A0,A1,A2,A3,WCLK,WE,D;
output O;

reg mem[0:15];

wire #1 dly_WE = WE;
wire #1 dly_D = D;
wire [3:0] addr = {A3,A2,A1,A0};
wire [3:0] #1 dly_addr = addr;

always @(posedge WCLK)
begin
  if (dly_WE) mem[dly_addr] = dly_D;
end

reg [3:0] rdaddr;
reg O;
always @*
begin
  rdaddr = dly_addr;
  #1;
  O = mem[rdaddr];
end
endmodule