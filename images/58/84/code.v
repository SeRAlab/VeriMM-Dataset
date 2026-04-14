module top_module(
    address,
    is_sector1_writable,
    is_sector2_writable,
    is_sector3_writable,
    is_sector4_writable,
    is_sector5_writable,
    is_addr_writable
);parameter FLASH_ADDR_WIDTH = 23;
    parameter SECTOR1_START_ADDR = 1;
    parameter SECTOR1_END_ADDR = 1;
    parameter SECTOR2_START_ADDR = 1;
    parameter SECTOR2_END_ADDR = 1;
    parameter SECTOR3_START_ADDR = 1;
    parameter SECTOR3_END_ADDR = 1;
    parameter SECTOR4_START_ADDR = 1;
    parameter SECTOR4_END_ADDR = 1;
    parameter SECTOR5_START_ADDR = 1;
    parameter SECTOR5_END_ADDR = 1;

    input [FLASH_ADDR_WIDTH-1:0] address;
    input is_sector1_writable;
    input is_sector2_writable;
    input is_sector3_writable;
    input is_sector4_writable;
    input is_sector5_writable;
    output is_addr_writable;

    wire is_sector1_addr;
    wire is_sector2_addr;
    wire is_sector3_addr;
    wire is_sector4_addr;
    wire is_sector5_addr;

    assign is_sector1_addr = ((address >= SECTOR1_START_ADDR) && (address <= SECTOR1_END_ADDR));
    assign is_sector2_addr = ((address >= SECTOR2_START_ADDR) && (address <= SECTOR2_END_ADDR));
    assign is_sector3_addr = ((address >= SECTOR3_START_ADDR) && (address <= SECTOR3_END_ADDR));
    assign is_sector4_addr = ((address >= SECTOR4_START_ADDR) && (address <= SECTOR4_END_ADDR));
    assign is_sector5_addr = ((address >= SECTOR5_START_ADDR) && (address <= SECTOR5_END_ADDR));

    assign is_addr_writable = ((is_sector1_writable && is_sector1_addr) ||
                               (is_sector2_writable && is_sector2_addr) ||
                               (is_sector3_writable && is_sector3_addr) ||
                               (is_sector4_writable && is_sector4_addr) ||
                               (is_sector5_writable && is_sector5_addr));

endmodule