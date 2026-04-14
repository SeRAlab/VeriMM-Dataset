module a25_wishbone_buf (
input                       i_clk,
input                       i_req,
input                       i_write,
input       [127:0]         i_wdata,
input       [15:0]          i_be,
input       [31:0]          i_addr,
output      [127:0]         o_rdata,
output                      o_ack,
output                      o_valid,
input                       i_accepted,
output                      o_write,
output      [127:0]         o_wdata,
output      [15:0]          o_be,
output      [31:0]          o_addr,
input       [127:0]         i_rdata,
input                       i_rdata_valid
);
reg  [1:0]                  wbuf_used_r     = 'd0;
reg  [127:0]                wbuf_wdata_r    [1:0]; 
reg  [31:0]                 wbuf_addr_r     [1:0]; 
reg  [15:0]                 wbuf_be_r       [1:0]; 
reg  [1:0]                  wbuf_write_r    = 'd0;
reg                         wbuf_wp_r       = 'd0;        
reg                         wbuf_rp_r       = 'd0;        
reg                         busy_reading_r  = 'd0;
reg                         wait_rdata_valid_r = 'd0;
wire                        in_wreq;
reg                         ack_owed_r      = 'd0;
assign in_wreq = i_req && i_write;
assign push    = i_req && !busy_reading_r && (wbuf_used_r == 2'd1 || (wbuf_used_r == 2'd0 && !i_accepted));
assign pop     = o_valid && i_accepted && wbuf_used_r != 2'd0;
always @(posedge i_clk)
    if (push && pop)
        wbuf_used_r     <= wbuf_used_r;
    else if (push)
        wbuf_used_r     <= wbuf_used_r + 1'd1;
    else if (pop)
        wbuf_used_r     <= wbuf_used_r - 1'd1;
always @(posedge i_clk)
    if (push && in_wreq && !o_ack)
        ack_owed_r = 1'd1;
    else if (!i_req && o_ack)
        ack_owed_r = 1'd0;
always @(posedge i_clk)
    if (push)
        begin
        wbuf_wdata_r [wbuf_wp_r]   <= i_wdata;
        wbuf_addr_r  [wbuf_wp_r]   <= i_addr;
        wbuf_be_r    [wbuf_wp_r]   <= i_write ? i_be : 16'hffff;
        wbuf_write_r [wbuf_wp_r]   <= i_write;
        wbuf_wp_r                  <= !wbuf_wp_r;
        end
always @(posedge i_clk)
    if (pop)
        wbuf_rp_r                  <= !wbuf_rp_r;
assign o_wdata = wbuf_used_r != 2'd0 ? wbuf_wdata_r[wbuf_rp_r] : i_wdata;
assign o_write = wbuf_used_r != 2'd0 ? wbuf_write_r[wbuf_rp_r] : i_write;
assign o_addr  = wbuf_used_r != 2'd0 ? wbuf_addr_r [wbuf_rp_r] : i_addr;
assign o_be    = wbuf_used_r != 2'd0 ? wbuf_be_r   [wbuf_rp_r] : i_write ? i_be : 16'hffff;
assign o_ack   = (in_wreq ? (wbuf_used_r == 2'd0) : i_rdata_valid) || (ack_owed_r && pop);
assign o_valid = (wbuf_used_r != 2'd0 || i_req) && !wait_rdata_valid_r;
assign o_rdata = i_rdata;
always@(posedge i_clk)
    if (o_valid && !o_write)
        busy_reading_r <= 1'd1;
    else if (i_rdata_valid)
        busy_reading_r <= 1'd0;
always@(posedge i_clk)
    if (o_valid && !o_write && i_accepted)
        wait_rdata_valid_r <= 1'd1;
    else if (i_rdata_valid)  
        wait_rdata_valid_r <= 1'd0;
endmodule