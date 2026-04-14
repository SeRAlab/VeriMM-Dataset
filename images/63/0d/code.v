module top_module(
    input clk,
    input reset,
    input [1:0] slave_address,
    input [3:0] slave_byteenable,
    input slave_read,
    input slave_write,
    input [31:0] slave_writedata,
    input [31:0] master_readdata,
    input master_waitrequest,
    output [31:0] slave_readdata,
    output slave_waitrequest,
    output [1:0] master_address,
    output [3:0] master_byteenable,
    output master_read,
    output master_write,
    output [31:0] master_writedata
);parameter ADDRESS_TRANSLATION_MASK = 32'hC0000000;

reg [31:0] slave_readdata_reg;
reg slave_waitrequest_reg;
reg [1:0] master_address_reg;
reg [3:0] master_byteenable_reg;
reg master_read_reg;
reg master_write_reg;
reg [31:0] master_writedata_reg;

always @(posedge clk) begin
    if (reset) begin
        slave_readdata_reg <= 0;
        slave_waitrequest_reg <= 0;
        master_address_reg <= 0;
        master_byteenable_reg <= 0;
        master_read_reg <= 0;
        master_write_reg <= 0;
        master_writedata_reg <= 0;
    end else begin
        if (slave_address[1] == 1'b0) begin
            slave_readdata_reg <= master_readdata | ADDRESS_TRANSLATION_MASK;
            master_writedata_reg <= slave_writedata & ~ADDRESS_TRANSLATION_MASK;
        end else begin
            slave_readdata_reg <= master_readdata;
            master_writedata_reg <= slave_writedata;
        end
        slave_waitrequest_reg <= master_waitrequest;
        master_address_reg <= slave_address;
        master_byteenable_reg <= slave_byteenable;
        master_read_reg <= slave_read;
        master_write_reg <= slave_write;
    end
end

assign slave_readdata = slave_readdata_reg;
assign slave_waitrequest = slave_waitrequest_reg;
assign master_address = master_address_reg;
assign master_byteenable = master_byteenable_reg;
assign master_read = master_read_reg;
assign master_write = master_write_reg;
assign master_writedata = master_writedata_reg;

endmodule