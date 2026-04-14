module top_module(
  clk_i,
  rst_i,

  data_i,
  enq_i,
  full_o,
  count_o,

  data_o,
  valid_o,
  deq_i
);parameter fifo_width     = 32;
parameter fifo_bit_depth = 6;

input clk_i, rst_i;

input        [fifo_width-1:0] data_i;
input                         enq_i;
output                        full_o;
output reg [fifo_bit_depth:0] count_o;

output reg [fifo_width-1:0] data_o;
output reg                  valid_o;
input                       deq_i;



reg   [fifo_width-1:0] fifo_data [2**(fifo_bit_depth)-1:0];
reg [fifo_bit_depth:0] fifo_head, fifo_tail;
reg [fifo_bit_depth:0] next_tail;



wire next_full = fifo_head[fifo_bit_depth-1:0] == next_tail[fifo_bit_depth-1:0] &&
                 fifo_head[fifo_bit_depth]     != next_tail[fifo_bit_depth];
always @(posedge clk_i or posedge rst_i)
  if (rst_i)
  begin
    fifo_tail <= 1'b0;
    next_tail <= 1'b1;
  end
  else if (!next_full && enq_i)
  begin
     
     fifo_data[fifo_tail[fifo_bit_depth-1:0]] <= data_i;
     next_tail <= next_tail + 1'b1;
     fifo_tail <= next_tail;
   end

assign full_o = next_full;

always @(posedge clk_i or posedge rst_i)
  if(rst_i)
    count_o <= 1'b0;
  else if(enq_i & ~deq_i & ~next_full)
    count_o <= count_o + 1'b1;
  else if(~enq_i & deq_i & valid_o)
    count_o <= count_o - 1'b1;


wire is_empty = (fifo_head == fifo_tail);
always @(posedge clk_i or posedge rst_i)
  if (rst_i) begin
    valid_o <= 1'b0;
    fifo_head <= 1'b0;
  end 
  else
  begin        
    if (!is_empty)
    begin
      if (!valid_o || deq_i)
        fifo_head <= fifo_head + 1'b1;

      valid_o <= 1'b1;
    end
    else if (deq_i)
      valid_o <= 1'b0;
  end

always @(posedge clk_i)
    
    
    
  if (!valid_o || deq_i)
    data_o <= fifo_data[fifo_head[fifo_bit_depth-1:0]];

endmodule