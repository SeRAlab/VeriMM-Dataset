module top_module(
	clk,
	addr_in,
	bank0_addr,
	bank1_addr,
	bank2_addr,
	bank3_addr,
	sel,
	odd
);input  clk;
input  [12:0]addr_in;
output [9:0]bank0_addr;
output [9:0]bank1_addr;
output [9:0]bank2_addr;
output [9:0]bank3_addr;
output [1:0]sel;
output odd;

reg [9:0] bank0_addr;
reg [9:0] bank1_addr;
reg [9:0] bank2_addr;
reg [9:0] bank3_addr;
reg [1:0] sel_dlya;
reg [1:0] sel_dlyb;
reg [1:0] sel;
reg odd_dlya;
reg odd_dlyb;
reg odd;

wire [9:0] addr = addr_in[12:3];
wire [9:0] addr_pone = addr_in[12:3] + 1;




always@(posedge clk) begin
  odd_dlya <= addr_in[0];
  sel_dlya <= addr_in[2:1];
  end

always@(posedge clk) begin
  odd_dlyb <= odd_dlya;
  sel_dlyb <= sel_dlya;
  end
  
always@(posedge clk) begin
  odd <= odd_dlyb;
  sel <= sel_dlyb;
  end

 

always@(posedge clk) begin
  case(addr_in[2:1])
    2'b00: begin
      bank0_addr <= addr;
      bank1_addr <= addr;
      bank2_addr <= addr;
      bank3_addr <= addr;
      end
    2'b01: begin
      bank0_addr <= addr_pone;
      bank1_addr <= addr;
      bank2_addr <= addr;
      bank3_addr <= addr;
      end
    2'b10: begin
      bank0_addr <= addr_pone;
      bank1_addr <= addr_pone;
      bank2_addr <= addr;
      bank3_addr <= addr;
      end
    2'b11: begin
      bank0_addr <= addr_pone;
      bank1_addr <= addr_pone;
      bank2_addr <= addr_pone;
      bank3_addr <= addr;
      end
    endcase
  end
  
endmodule