module top_module(clk, rst,
			pointer, pointer_s, ch_csr, ch_txsz, ch_adr0, ch_adr1,
			ch_am0, ch_am1, sw_pointer, ch_stop, ch_dis, irq,

			wb_rf_din, wb_rf_adr, wb_rf_we, wb_rf_re,

			
			ch_sel, ndnr,

			
			dma_busy, dma_err, dma_done, dma_done_all,

			
			de_csr, de_txsz, de_adr0, de_adr1,
			de_csr_we, de_txsz_we, de_adr0_we, de_adr1_we,
			de_fetch_descr, dma_rest,
			ptr_set

		);parameter	CH_NO = 0;
parameter	HAVE_ARS = 1;
parameter	HAVE_ED  = 1;
parameter	HAVE_CBUF= 1;

input		clk, rst;

output	[31:0]	pointer;
output	[31:0]	pointer_s;
output	[31:0]	ch_csr;
output	[31:0]	ch_txsz;
output	[31:0]	ch_adr0;
output	[31:0]	ch_adr1;
output	[31:0]	ch_am0;
output	[31:0]	ch_am1;
output	[31:0]	sw_pointer;
output		ch_stop;
output		ch_dis;
output		irq;

input	[31:0]	wb_rf_din;
input	[7:0]	wb_rf_adr;
input		wb_rf_we;
input		wb_rf_re;

input	[4:0]	ch_sel;
input		ndnr;


input		dma_busy, dma_err, dma_done, dma_done_all;


input	[31:0]	de_csr;
input	[11:0]	de_txsz;
input	[31:0]	de_adr0;
input	[31:0]	de_adr1;
input		de_csr_we, de_txsz_we, de_adr0_we, de_adr1_we, ptr_set;
input		de_fetch_descr;
input		dma_rest;

assign		pointer = 32'h0;
assign		pointer_s = 32'h0;
assign		ch_csr = 32'h0;
assign		ch_txsz = 32'h0;
assign		ch_adr0 = 32'h0;
assign		ch_adr1 = 32'h0;
assign		ch_am0 = 32'h0;
assign		ch_am1 = 32'h0;
assign		sw_pointer = 32'h0;
assign		ch_stop = 1'b0;
assign		ch_dis = 1'b0;
assign		irq = 1'b0;

endmodule