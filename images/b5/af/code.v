module top_module(
    clk, reset, o_stall, i_valid, i_address, i_writedata, i_stall, o_valid, i_byteenable,
    o_active, 
    avm_enable, avm_address, avm_write, avm_writeack, avm_writedata, avm_byteenable, avm_waitrequest
);parameter AWIDTH=32;    
parameter WIDTH_BYTES=4;     
parameter MWIDTH_BYTES=32;   
parameter ALIGNMENT_ABITS=2;    
parameter USE_BYTE_EN=0;

localparam WIDTH=8*WIDTH_BYTES;
localparam MWIDTH=8*MWIDTH_BYTES;
localparam BYTE_SELECT_BITS=$clog2(MWIDTH_BYTES);
localparam SEGMENT_SELECT_BITS=BYTE_SELECT_BITS-ALIGNMENT_ABITS;
localparam SEGMENT_WIDTH=8*(2**ALIGNMENT_ABITS);
localparam SEGMENT_WIDTH_BYTES=(2**ALIGNMENT_ABITS);



input clk;
input reset;


output o_stall;
input i_valid;
input [AWIDTH-1:0] i_address;
input [WIDTH-1:0] i_writedata;
input [WIDTH_BYTES-1:0] i_byteenable;

input i_stall;
output o_valid;
output reg o_active;


output avm_enable;
output [AWIDTH-1:0] avm_address;
output avm_write;
input avm_writeack;
output reg [MWIDTH-1:0] avm_writedata;
output reg [MWIDTH_BYTES-1:0] avm_byteenable;
input avm_waitrequest;




wire [WIDTH_BYTES-1:0] byteenable;

assign byteenable = USE_BYTE_EN ? i_byteenable : {WIDTH_BYTES{1'b1}}; 


assign avm_address = ((i_address >> BYTE_SELECT_BITS) << BYTE_SELECT_BITS);
assign avm_write = i_valid;



generate
if(SEGMENT_SELECT_BITS > 0)
begin
  wire [SEGMENT_SELECT_BITS-1:0] segment_select;
  assign segment_select = i_address[ALIGNMENT_ABITS +: BYTE_SELECT_BITS-ALIGNMENT_ABITS];
  always@(*)
  begin
    avm_writedata = {MWIDTH{1'bx}};
    avm_writedata[segment_select*SEGMENT_WIDTH +: WIDTH] = i_writedata;

    avm_byteenable = {MWIDTH_BYTES{1'b0}};
    avm_byteenable[segment_select*SEGMENT_WIDTH_BYTES +: WIDTH_BYTES] = byteenable;
  end
end
else
begin
  always@(*)
  begin
    avm_writedata = i_writedata;
    avm_byteenable = byteenable;
  end
end
endgenerate

assign avm_enable = ~i_stall;

assign o_stall = i_stall; 
assign o_valid = avm_writeack; 

endmodule