module top_module(
  input  wire sti_data,
  input  wire clk,
  input  wire wrenb,
  input  wire din,
  output wire dout,
  input  wire cin,
  output wire cout
);wire       hit;
reg [15:0] mem;

always @(posedge clk)
if (wrenb) mem <= {mem, din};

assign hit  = mem[{3'b000, sti_data}];
assign dout = mem[15];

assign cout = hit ? cin : din;

endmodule