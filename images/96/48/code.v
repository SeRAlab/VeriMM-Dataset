module top_module(
    input rst_,

    input [4:0] mem_i_waddr,
    input mem_i_wreg,
    input [31:0] mem_i_wdata,

    input mem_i_we_hilo,
    input [31:0] mem_i_wdata_hi,
    input [31:0] mem_i_wdata_lo,

    output reg mem_o_wreg,
    output reg [4:0] mem_o_waddr,
    output reg [31:0] mem_o_wdata,

    output reg mem_o_we_hilo,
    output reg [31:0] mem_o_wdata_hi,
    output reg [31:0] mem_o_wdata_lo
);always @* begin
    mem_o_waddr = !rst_ ? 'b0 : mem_i_waddr;
    mem_o_wreg = !rst_ ? 'b0 : mem_i_wreg;
    mem_o_wdata = !rst_ ? 'b0 : mem_i_wdata;

    mem_o_we_hilo = !rst_ ? 'b0 : mem_i_we_hilo;
    mem_o_wdata_hi = !rst_ ? 'b0 : mem_i_wdata_hi;
    mem_o_wdata_lo = !rst_ ? 'b0 : mem_i_wdata_lo;
end

endmodule