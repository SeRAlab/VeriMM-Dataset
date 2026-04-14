module generic_sram_line_en
#(
parameter DATA_WIDTH            = 128,
parameter ADDRESS_WIDTH         = 7,
parameter INITIALIZE_TO_ZERO    = 0
)
(
input                           i_clk,
input      [DATA_WIDTH-1:0]     i_write_data,
input                           i_write_enable,
input      [ADDRESS_WIDTH-1:0]  i_address,
output reg [DATA_WIDTH-1:0]     o_read_data
);                                                     
reg [DATA_WIDTH-1:0]   mem  [0:2**ADDRESS_WIDTH-1];
generate
if ( INITIALIZE_TO_ZERO ) begin : init0
integer i;
initial
    begin
    for (i=0;i<2**ADDRESS_WIDTH;i=i+1)
        mem[i] <= 'd0;
    end
end
endgenerate
always @(posedge i_clk)
    begin
    o_read_data <= i_write_enable ? {DATA_WIDTH{1'd0}} : mem[i_address];
    if (i_write_enable)
        mem[i_address] <= i_write_data;
    end
endmodule