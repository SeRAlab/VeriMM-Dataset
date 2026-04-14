module top_module(
  clka,
  ena,
  wea,
  addra,
  dina,
  douta,
  clkb,
  enb,
  web,
  addrb,
  dinb,
  doutb
);reg [15:0] mem [0:16383];

input wire clka;
input wire ena;
input wire [0 : 0] wea;
input wire [13 : 0] addra;
input wire [15 : 0] dina;
output wire [15 : 0] douta;
input wire clkb;
input wire enb;
input wire [0 : 0] web;
input wire [13 : 0] addrb;
input wire [15 : 0] dinb;
output wire [15 : 0] doutb;

assign douta = mem[addra];
assign doutb = mem[addrb];

always @(posedge clka) begin
  if (ena == 1'b1) begin
    if (wea == 1'b1) begin
      mem[addra] <= dina;
    end
  end
end

always @(posedge clkb) begin
  if (enb == 1'b1) begin
    if (web == 1'b1) begin
      mem[addrb] <= dinb;
    end
  end
end

endmodule