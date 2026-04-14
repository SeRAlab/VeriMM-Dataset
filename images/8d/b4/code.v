module top_module(
  input                           clk_in,   // input clock (system clock)
  input                           rst,      // reset
  input                           enable,   // clock enable
  input                           go,       // start transfer
  input                           last_clk, // last clock
  input     [31:0]                divider,  // clock divider (output clock is divided by this value)
  output  reg                     clk_out,  // output clock
  output  reg                     pos_edge, // pulse marking positive edge of clk_out
  output  reg                     neg_edge  // pulse marking negative edge of clk_out
);// Counter for counting clock cycles
reg       [31:0]                cnt;

// Wires for detecting counter values
wire                            cnt_zero;
wire                            cnt_one;

// Detect when counter is zero
assign cnt_zero = (cnt == 32'h0);

// Detect when counter is one
assign cnt_one = (cnt == 32'h00000001);

// Counter counts half period
always @(posedge clk_in or posedge rst) begin
  if(rst) begin
    cnt <= 32'h00000001;
  end
  else begin
    if(!enable || cnt_zero) begin
      cnt <= divider;
    end
    else begin
      cnt <= cnt - 32'h00000001;
    end
  end
end

// clk_out is asserted every other half period
always @(posedge clk_in or posedge rst) begin
  if(rst) begin
    clk_out <= 1'b0;
  end
  else begin
    clk_out <= (enable && cnt_zero && (!last_clk || clk_out)) ? ~clk_out : clk_out;
  end
end

// Pos and neg edge signals
always @(posedge clk_in or posedge rst) begin
  if(rst) begin
    pos_edge <= 1'b0;
    neg_edge <= 1'b0;
  end
  else begin
    pos_edge <= (enable && !clk_out && cnt_one) || (!(|divider) && clk_out) || (!(|divider) && go && !enable);
    neg_edge <= (enable && clk_out && cnt_one) || (!(|divider) && !clk_out && enable);
  end
end

endmodule