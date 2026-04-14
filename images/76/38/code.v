module top_module(
    output M2S_AXI_ACLK,


    
    output M2S_AXI_AWVALID,
    input M2S_AXI_AWREADY,
    output [31:0] M2S_AXI_AWADDR,
    output [1:0] M2S_AXI_AWBURST,
    output [3:0] M2S_AXI_AWLEN,
    output [1:0] M2S_AXI_AWSIZE,
    
    output M2S_AXI_WVALID,
    input M2S_AXI_WREADY,
    output M2S_AXI_WLAST,
    output [63:0] M2S_AXI_WDATA,
    output [7:0] M2S_AXI_WSTRB,
    
    input M2S_AXI_BVALID,
    output M2S_AXI_BREADY,
    input [1:0] M2S_AXI_BRESP

);assign M2S_AXI_ACLK = 1'b0;

    
    assign M2S_AXI_AWVALID = 1'b0;
    assign M2S_AXI_AWADDR = 33'b0;
    assign M2S_AXI_AWBURST = 2'b0;
    assign M2S_AXI_AWLEN = 4'b0;
    assign M2S_AXI_AWSIZE = 2'b0;
    assign M2S_AXI_WVALID = 1'b0;
    assign M2S_AXI_WLAST = 1'b0;
    assign M2S_AXI_WDATA = 64'b0;
    assign M2S_AXI_WSTRB = 8'b0;
    assign M2S_AXI_BREADY = 1'b0;


endmodule