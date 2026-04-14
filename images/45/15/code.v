module top_module(
   
   out,
   
   clk, reset_l, t_wa, d, t_addr
   );input	clk;
   input	reset_l;

   reg [63:0] 	m_w0 [47:0];
   reg [63:0] 	m_w1 [23:0];
   reg [63:0] 	m_w2 [23:0];
   reg [63:0] 	m_w3 [23:0];
   reg [63:0] 	m_w4 [23:0];
   reg [63:0] 	m_w5 [23:0];

   input [8:0] 	t_wa;
   input [63:0] 	d;

   always @ (posedge clk) begin
      if (~reset_l) begin : blk
	 integer i;

	 for (i=0; i<48; i=i+1) begin
	    m_w0[i] <= 64'h0;
	 end

	 for (i=0; i<24; i=i+1) begin
	    m_w1[i] <= 64'h0;
	    m_w2[i] <= 64'h0;
	    m_w3[i] <= 64'h0;
	    m_w4[i] <= 64'h0;
	    m_w5[i] <= 64'h0;
	 end
      end
      else begin
	 casez (t_wa[8:6])
	   3'd0: m_w0[t_wa[5:0]] <= d;
	   3'd1: m_w1[t_wa[4:0]] <= d;
	   3'd2: m_w2[t_wa[4:0]] <= d;
	   3'd3: m_w3[t_wa[4:0]] <= d;
	   3'd4: m_w4[t_wa[4:0]] <= d;
	   default: m_w5[t_wa[4:0]] <= d;
	 endcase
      end
   end

   input [8:0] t_addr;

   wire [63:0]	t_w0 = m_w0[t_addr[5:0]];
   wire [63:0]	t_w1 = m_w1[t_addr[4:0]];
   wire [63:0]	t_w2 = m_w2[t_addr[4:0]];
   wire [63:0]	t_w3 = m_w3[t_addr[4:0]];
   wire [63:0]	t_w4 = m_w4[t_addr[4:0]];
   wire [63:0]	t_w5 = m_w5[t_addr[4:0]];

   output reg [63:0] 	out;
   always @* begin
      casez (t_addr[8:6])
	3'd0: out = t_w0;
	3'd1: out = t_w1;
	3'd2: out = t_w2;
	3'd3: out = t_w3;
	3'd4: out = t_w4;
	default: out = t_w5;
      endcase
   end

endmodule