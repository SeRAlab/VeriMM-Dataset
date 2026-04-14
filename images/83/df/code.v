module top_module(
    input clk,
    input rst,
    input [12:0] mem_addr,
    input [7:0] mem_din,
    input mem_we,
    input mem_re,
    output reg [7:0] mem_dout,
    output reg mem_a,
    output reg [2:0] mem_ba,
    output reg mem_ck,
    output reg mem_ck_n,
    output reg mem_cke,
    output reg mem_cs_n,
    output reg mem_ras_n,
    output reg mem_cas_n,
    output reg mem_we_n,
    output reg mem_reset_n,
    inout [7:0] mem_dq,
    inout mem_dqs,
    inout mem_dqs_n,
    output reg mem_odt,
    output reg mem_dm
);always @ (posedge clk or negedge rst) begin
        if(!rst) begin
            mem_a <= 0;
            mem_ba <= 0;
            mem_ck <= 0;
            mem_ck_n <= 1;
            mem_cke <= 0;
            mem_cs_n <= 1;
            mem_ras_n <= 1;
            mem_cas_n <= 1;
            mem_we_n <= 1;
            mem_reset_n <= 1;
            mem_odt <= 0;
            mem_dm <= 0;
        end else begin
            mem_a <= mem_addr;
            mem_ba <= mem_addr[2:0];
            mem_ck <= clk;
            mem_ck_n <= ~clk;
            mem_cke <= 1;
            mem_cs_n <= 0;
            mem_ras_n <= 0;
            mem_cas_n <= 0;
            mem_we_n <= ~mem_we;
            mem_reset_n <= 1;
            mem_odt <= 0;
            mem_dm <= 0;
        end
    end
    
    assign mem_dq = (mem_re) ? mem_dout : 8'bZZZZZZZZ;
    assign mem_dout = (mem_re) ? mem_dq : 8'bZZZZZZZZ;
    assign mem_dqs = 1'b0;
    assign mem_dqs_n = 1'b1;

endmodule