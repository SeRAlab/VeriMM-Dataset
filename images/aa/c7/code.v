module top_module(
   input rst, clk,
   input [31:0] bus_addr,
   input [3:0] bus_byte_enable,
   input bus_read, bus_write,
   input [31:0] bus_write_data,
   output reg bus_ack,
   output reg [31:0] bus_read_data
);reg [31:0] audio_fifo_address = 32'h00003044;
   reg [31:0] audio_left_address = 32'h00003048;
   reg [31:0] audio_right_address = 32'h0000304c;
   reg [31:0] counter;

   always @(posedge clk) begin
      if (rst) begin
         bus_read_data <= 32'b0;
         bus_ack <= 1'b0;
         counter <= 32'b0;
      end
      else begin
         if (bus_read) begin
            if (bus_addr == audio_fifo_address) begin
               bus_read_data <= (8'd3 << 24) | 8'd2;
            end
            else if (bus_addr == audio_right_address) begin
               counter <= counter + 1;
               bus_read_data <= counter;
            end
         end
         bus_ack <= bus_read | bus_write;
      end
   end

   // Ensure that the EBABWrapper module is defined somewhere in your design
   // If it is defined in another file, include it in your compilation command.
   // If it needs to be instantiated here, please provide its definition.

endmodule