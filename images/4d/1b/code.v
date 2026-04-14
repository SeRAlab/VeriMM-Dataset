module top_module(Q,
    E,
    D,
    clk_IBUF_BUFG,
    AR);output reg [31:0]Q;
  input [0:0]E;
  input [31:0]D;
  input clk_IBUF_BUFG;
  input [0:0]AR;

  reg [31:0] data_array [0:1]; // create an array to store data at two different addresses
  integer address; // declare an integer to hold the converted address

  always @(posedge clk_IBUF_BUFG) begin
    if (E == 1) begin // if enable input is high, store data at specified address
      address = AR; // convert address input to integer
      data_array[address] <= D; // store input data at specified address
    end
  end

  always @(negedge clk_IBUF_BUFG) begin
    if (E == 0) begin // if enable input is low, output data at specified address
      address = AR; // convert address input to integer
      Q <= data_array[address]; // output stored data at specified address
    end
  end

endmodule