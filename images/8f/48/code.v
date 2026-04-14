module top_module(
  input [2:0] count_in,
  output reg mem_in_ctrl_s
  );always @ ( * ) begin
  case (count_in)
    1: mem_in_ctrl_s = 1;
    3: mem_in_ctrl_s = 1;
    5: mem_in_ctrl_s = 1;
    default: mem_in_ctrl_s = 0;
  endcase
end
endmodule