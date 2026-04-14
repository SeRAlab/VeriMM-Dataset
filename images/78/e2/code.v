module top_module(
    
     input           clk_i
    ,input           rst_i
    ,input  [ 10:0]  addr_i
    ,input  [ 31:0]  data_i
    ,input           wr_i

    
    ,output [ 31:0]  data_o
);reg [31:0]   ram [2047:0] ;
reg [31:0]   ram_read_q;


always @ (posedge clk_i)
begin
    if (wr_i)
        ram[addr_i] <= data_i;
    ram_read_q <= ram[addr_i];
end

assign data_o = ram_read_q;



endmodule