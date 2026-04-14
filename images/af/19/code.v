module top_module(
  input [3:0] data_in,
  input [1:0] select,
  output reg data_out
);always @(*) begin
    data_out = (select == 2'b00) ? data_in[0] :
               (select == 2'b01) ? data_in[1] :
               (select == 2'b10) ? data_in[2] :
                                  data_in[3];
  end

endmodule