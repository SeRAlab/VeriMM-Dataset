module top_module(
  input clk,      // clock input
  input load,     // load input
  input control,  // control input
  input [7:0] data_in,  // input data
  output [7:0] data_out // output data
);reg [7:0] register;  // shift register

  always @ (posedge clk) begin
    if (load) begin  // if load is high, load the input data
      register <= data_in;
    end else begin  // otherwise, shift the data based on the control input
      if (control) begin  // shift left
        register <= {register[6:0], register[7]};
      end else begin  // shift right
        register <= {register[0], register[7:1]};
      end
    end
  end

  assign data_out = register;  // output the data in the shift register

endmodule