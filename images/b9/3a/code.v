module top_module(
    address,
    flash_addr
);parameter FLASH_ADDR_WIDTH = 23;
    parameter ADDR_RANGE1_END_ADDR = 1;
    parameter ADDR_RANGE2_END_ADDR = 1;
    parameter ADDR_RANGE1_OFFSET = 1;
    parameter ADDR_RANGE2_OFFSET = 1;
    parameter ADDR_RANGE3_OFFSET = 1;

    input [FLASH_ADDR_WIDTH-1:0] address;
    output [FLASH_ADDR_WIDTH-1:0] flash_addr;

    assign flash_addr = (address <= ADDR_RANGE1_END_ADDR[FLASH_ADDR_WIDTH-1:0]) ? (address + ADDR_RANGE1_OFFSET[FLASH_ADDR_WIDTH-1:0]) : 
                        (address <= ADDR_RANGE2_END_ADDR[FLASH_ADDR_WIDTH-1:0]) ? (address + ADDR_RANGE2_OFFSET[FLASH_ADDR_WIDTH-1:0]) :
                        (address + ADDR_RANGE3_OFFSET[FLASH_ADDR_WIDTH-1:0]);
    
endmodule