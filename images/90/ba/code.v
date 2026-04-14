module top_module(
  input [2:0] sel,
  input [3:0] data0,
  input [3:0] data1,
  input [3:0] data2,
  input [3:0] data3,
  input [3:0] data4,
  input [3:0] data5,
  output reg [3:0] out,
  output reg parity
);reg [3:0] mux_out [0:5];
  
  // Generate intermediate signals for each input data
  always @* begin
    mux_out[0] = data0;
    mux_out[1] = data1;
    mux_out[2] = data2;
    mux_out[3] = data3;
    mux_out[4] = data4;
    mux_out[5] = data5;
  end
  
  // Select the active input data using a 3-to-6 multiplexer
  always @* begin
    if (sel < 6) begin
      out = mux_out[sel];
    end else begin
      out = 4'b0;
    end
  end
  
  // Generate the parity bit using an XOR gate
  always @* begin
    parity = out[0] ^ out[1] ^ out[2] ^ out[3];
  end
  
endmodule