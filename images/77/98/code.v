module top_module(
  input [3:0] data_in,
  input [1:0] shift_amt,
  output [3:0] data_out
);assign data_out = (shift_amt == 2'b00) ? data_in :
                    (shift_amt == 2'b01) ? {data_in[2:0], 1'b0} :
                    (shift_amt == 2'b10) ? {data_in[1:0], 2'b00} :
                                          {data_in[0], 3'b000};
                                          
endmodule