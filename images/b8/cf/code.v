module top_module(
    input s_axi_aclk,
    input s_axi_aresetn,
    input s_axi_arvalid,
    input [2:0]s_axi_araddr,
    input s_axi_rready,
    output [11:0]s_axi_rdata,
    output s_axi_rvalid,
    input s_axi_awvalid,
    input [2:0]s_axi_awaddr,
    input s_axi_wvalid,
    input [11:0]s_axi_wdata,
    input s_axi_bready,
    output reg [3:0]gpio_io_t
);reg [11:0] mem [7:0];

assign s_axi_rdata = mem[s_axi_araddr][11:0];
assign s_axi_rvalid = s_axi_arvalid && s_axi_rready;

always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
        gpio_io_t <= 0;
    end else if (s_axi_awvalid) begin
        mem[s_axi_awaddr][11:0] <= s_axi_wdata;
        gpio_io_t <= s_axi_wdata[0];
    end
end

endmodule