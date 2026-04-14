module top_module(
     sram_clock, 
    sram_read,
    sram_read_address,
    sram_read_data,

    sram_write,
    sram_write_address,
    sram_write_data );input sram_clock;
    input sram_read;
    input [10:0] sram_read_address;
    output [31:0] sram_read_data;

    input sram_write;
    input [10:0] sram_write_address;
    input [31:0] sram_write_data;

reg[31:0] memory[2047:0];
reg read;
reg write;
reg[10:0] rd_addr;
reg[10:0] wr_addr;
reg[31:0] wr_data;
reg[31:0] sram_read_data;
always @(posedge sram_clock)
begin
    read <= sram_read;
    write <= sram_write;
    rd_addr <= sram_read_address;
    wr_addr <= sram_write_address;
    wr_data <= sram_write_data;

    if (sram_write)
    begin
        memory[sram_write_address] <= sram_write_data;
    end
end

always @(read or rd_addr ) 
begin
    sram_read_data = 0;
    if (read)
    begin
        sram_read_data = memory[rd_addr];
    end
end

endmodule