module top_module(
    address,
    is_addr_within_valid_range
);parameter FLASH_ADDR_WIDTH = 23;
    parameter MIN_VALID_ADDR = 1;
    parameter MAX_VALID_ADDR = 1;

    input [FLASH_ADDR_WIDTH-1:0] address;
    output is_addr_within_valid_range;
    
    assign is_addr_within_valid_range = (address >= MIN_VALID_ADDR) && (address <= MAX_VALID_ADDR);

endmodule