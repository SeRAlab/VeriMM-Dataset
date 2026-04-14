module top_module(
    input  io_valid_0,
    output io_chosen,
    input  io_ready);wire choose;

  assign io_chosen = choose;
  assign choose = io_valid_0 ? 1'h0 : 1'h1;
endmodule