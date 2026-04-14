module top_module(
    input           TCK
,   input  [3:0]    IO_CORE
,   output [3:0]    IO_CORE_LOGIC
);assign IO_CORE_LOGIC[0] = IO_CORE[0] & IO_CORE[1];
assign IO_CORE_LOGIC[1] = IO_CORE[0] | IO_CORE[1];         
assign IO_CORE_LOGIC[2] = IO_CORE[2] & IO_CORE[3];         
assign IO_CORE_LOGIC[3] = IO_CORE[2] | IO_CORE[3];         

endmodule