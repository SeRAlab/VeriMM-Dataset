module ChooseModule(
    input  io_valid_0,
    input  io_ready,
    output io_chosen
);

  assign io_chosen = io_ready ? ~io_valid_0 : 1'b1; 

endmodule