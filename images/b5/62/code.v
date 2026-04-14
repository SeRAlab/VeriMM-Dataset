module top_module(
    data_i,
    data_o
    );input   [16-1:0] data_i;
output  [32-1:0] data_o;


reg     [32-1:0] data_o;


always @ (data_i) begin
  data_o[16-1:0] = data_i;
  data_o[32-1:16] = {16{data_i[16-1]}};
end

endmodule