module top_module(input CLK, input process_CE, input [31:0] inp, output [15:0] process_output);parameter INSTANCE_NAME="INST";
  reg [15:0] unnamedbinop1637_delay1_validunnamednull0_CEprocess_CE;  always @ (posedge CLK) begin if (process_CE) begin unnamedbinop1637_delay1_validunnamednull0_CEprocess_CE <= {((inp[15:0])+(inp[31:16]))}; end end
  assign process_output = unnamedbinop1637_delay1_validunnamednull0_CEprocess_CE;
  
endmodule