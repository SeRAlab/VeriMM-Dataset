module top_module(
   input clk,
   input reset,
   input in_wr,
   input in_ctrl,
   output reg tx_fifo_wr_en,
   output reg [1:0] tx_input_state_nxt
);// state machine states
   localparam INPUT_IDLE = 2'b00;
   localparam INPUT_PKTS = 2'b01;

   // state machine registers
   reg [1:0] tx_input_state;

   // state machine logic
   always @* begin
      tx_fifo_wr_en = 1'b0; // Default value
      tx_input_state_nxt = tx_input_state; // Default to hold the state

      case (tx_input_state)
         INPUT_IDLE: begin
            if(in_wr) begin
               tx_fifo_wr_en = 1'b1;
               tx_input_state_nxt = INPUT_PKTS;
            end
         end
         INPUT_PKTS: begin
            if(in_wr) begin
               tx_fifo_wr_en = 1'b1;
               if(|in_ctrl) begin
                  tx_input_state_nxt = INPUT_IDLE;
               end
            end
         end
      endcase
   end
   
   always @(posedge clk) begin
      if(reset) begin
         tx_input_state <= INPUT_IDLE;
      end
      else begin
         tx_input_state <= tx_input_state_nxt;
      end
   end

endmodule