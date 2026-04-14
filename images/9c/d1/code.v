module top_module(clock, reset, enable, load, data_in, data_out);parameter DataSize = 4;
   
   input wire clock;
   input wire reset;
   input wire enable;
   input wire load;
   input wire [DataSize-1:0] data_in;
   
   output reg [DataSize-1:0] data_out;
   
   always @ (posedge clock or negedge reset) begin
      if (reset == 0) begin
         data_out <= 0;
      end
      else if (enable == 1) begin
         if (load == 1) begin
            data_out <= data_in;
         end
         else begin
            data_out <= data_out + 1;
         end
      end
   end // always @ (posedge clock or negedge reset)
   
endmodule