module top_module(

    output S2M_AXI_ACLK,

    
    input S2M_AXI_ARVALID,
    output S2M_AXI_ARREADY,
    input [31:0] S2M_AXI_ARADDR,
    input [11:0] S2M_AXI_ARID,

    output S2M_AXI_RVALID,
    input S2M_AXI_RREADY,
    output S2M_AXI_RLAST,
    output [31:0] S2M_AXI_RDATA,
    output [11:0] S2M_AXI_RID,

    output [1:0] S2M_AXI_RRESP,

    
    input S2M_AXI_AWVALID,
    output S2M_AXI_AWREADY,
    input [31:0] S2M_AXI_AWADDR,
    input [11:0] S2M_AXI_AWID,

    input S2M_AXI_WVALID,
    output S2M_AXI_WREADY,
    input [31:0] S2M_AXI_WDATA,
    input [3:0] S2M_AXI_WSTRB,

    output S2M_AXI_BVALID,
    input S2M_AXI_BREADY,
    output [1:0] S2M_AXI_BRESP,
    output [11:0] S2M_AXI_BID
);assign S2M_AXI_ACLK = 1'b0;
    
    assign S2M_AXI_ARREADY = 1'b0;
    assign S2M_AXI_RVALID = 1'b0;
    assign S2M_AXI_RLAST = 1'b0;
    assign S2M_AXI_RDATA = 32'b0;
    assign S2M_AXI_RID = 12'b0;
    assign S2M_AXI_RRESP = 2'b0;

    
    assign S2M_AXI_AWREADY = 1'b0;
    assign S2M_AXI_WREADY = 1'b0;
    assign S2M_AXI_BVALID = 1'b0;
    assign S2M_AXI_BRESP = 2'b0;
    assign S2M_AXI_BID = 12'b0;


endmodule