module top_module( 
    clk_i, 
    adr_i, 
    dat_i, 
    wr_i,
    dat_o
);//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
parameter  [31:0]       WIDTH = 8;
parameter  [31:0]       SIZE = 14;

//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------    
input                   clk_i /*verilator public*/;
output [(WIDTH - 1):0]  dat_o /*verilator public*/;
input [(WIDTH - 1):0]   dat_i /*verilator public*/;
input [(SIZE - 1):0]    adr_i /*verilator public*/;
input                   wr_i /*verilator public*/;

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
reg [(WIDTH - 1):0]     ram [((2<< (SIZE-1)) - 1):0] /*verilator public*/;
reg [(SIZE - 1):0]      rd_addr;
wire [(WIDTH - 1):0]    dat_o;

//-----------------------------------------------------------------
// Processes
//-----------------------------------------------------------------
always @ (posedge clk_i)
begin 
    if (wr_i == 1'b1)
        ram[adr_i] <= dat_i;
    rd_addr <= adr_i;
end

//-------------------------------------------------------------------
// Combinatorial
//-------------------------------------------------------------------
assign dat_o = ram[rd_addr];

endmodule