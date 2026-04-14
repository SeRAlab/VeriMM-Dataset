module top_module(
    input clk,
    input reset,

    input [17:0] address,
    input [1:0] byteenable,
    input read,
    input write,
    input [15:0] writedata,

    inout [15:0] SRAM_DQ,

    output reg [15:0] readdata,
    output reg readdatavalid,

    output reg [17:0] SRAM_ADDR,
    output reg SRAM_LB_N,
    output reg SRAM_UB_N,
    output reg SRAM_CE_N,
    output reg SRAM_OE_N,
    output reg SRAM_WE_N
);reg is_read, is_write;
reg [15:0] writedata_reg;

always @(posedge clk) begin
    if (reset) begin
        is_read <= 1'b0;
        is_write <= 1'b0;
    end else begin
        is_read <= read;
        is_write <= write;
    end
end

always @(posedge clk) begin
    if (reset) begin
        writedata_reg <= 16'h0000;
    end else begin
        writedata_reg <= writedata;
    end
end

assign SRAM_DQ = (is_write) ? writedata_reg : 16'hzzzz;

always @(posedge clk) begin
    if (reset) begin
        SRAM_ADDR <= 18'h00000;
        SRAM_LB_N <= 1'b1;
        SRAM_UB_N <= 1'b1;
        SRAM_CE_N <= 1'b1;
        SRAM_OE_N <= 1'b1;
        SRAM_WE_N <= 1'b1;
        readdata <= 16'h0000;
        readdatavalid <= 1'b0;
    end else begin
        SRAM_ADDR <= address;
        SRAM_LB_N <= ~(byteenable[0] & (read | write));
        SRAM_UB_N <= ~(byteenable[1] & (read | write));
        SRAM_CE_N <= ~(read | write);
        SRAM_OE_N <= ~read;
        SRAM_WE_N <= ~write;
        readdata <= SRAM_DQ;
        readdatavalid <= is_read;
    end
end

endmodule