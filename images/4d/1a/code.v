module top_module(CLK, RST, ENQ, FULL_N, DEQ, EMPTY_N, CLR);parameter CAPACITY = 10;
   parameter guarded = 1;

   input CLK;
   input RST;
   input ENQ;
   input DEQ;
   input CLR;

   output FULL_N;
   output EMPTY_N;

   reg [CAPACITY-1:0] data;
   reg [CAPACITY-1:0] ptr;
   reg [CAPACITY-1:0] next_ptr;
   reg [CAPACITY-1:0] clear_cnt;
   reg [CAPACITY-1:0] enq_cnt;
   reg [CAPACITY-1:0] deq_cnt;
   reg empty_reg;
   reg full_reg;

   assign FULL_N = ~full_reg;
   assign EMPTY_N = ~empty_reg;

   always @ (posedge CLK) begin
      if (RST) begin
         ptr <= 0;
         next_ptr <= 0;
         clear_cnt <= 0;
         enq_cnt <= 0;
         deq_cnt <= 0;
         empty_reg <= 1;
         full_reg <= 0;
      end else begin
         if (CLR) begin
            ptr <= 0;
            next_ptr <= 0;
            clear_cnt <= CAPACITY;
            enq_cnt <= 0;
            deq_cnt <= 0;
            empty_reg <= 1;
            full_reg <= 0;
         end else begin
            if (ENQ && ~full_reg) begin
               data[ptr] <= enq_cnt;
               next_ptr <= ptr + 1;
               enq_cnt <= enq_cnt + 1;
            end
            if (DEQ && ~empty_reg) begin
               next_ptr <= ptr + 1;
               deq_cnt <= deq_cnt + 1;
            end
            ptr <= next_ptr;
            empty_reg <= (ptr == next_ptr) && (clear_cnt == 0);
            full_reg <= (ptr != next_ptr) && (clear_cnt == 0);
         end
         if (clear_cnt > 0) begin
            clear_cnt <= clear_cnt - 1;
         end
      end
   end

   always @ (posedge CLK) begin
      if (RST) begin
         $display("FIFO reset");
      end else begin
         if (~empty_reg && DEQ) begin
            $display("Warning: FIFO is not empty, dequeuing");
         end
         if (~full_reg && ENQ && (~DEQ || guarded)) begin
            $display("Warning: FIFO is not full, enqueuing");
         end
      end
   end

endmodule