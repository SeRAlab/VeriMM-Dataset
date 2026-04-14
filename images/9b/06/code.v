module top_module(
  input clk,
  input rst,
  input reset,
  input start,
  input [15:0] d_in,
  input cs,
  input [1:0] addr,
  input rd,
  input wr,
  input micData,
  output reg [15:0] d_out
);reg [15:0] mem [0:3];

  always @(posedge clk) begin
    if (rst == 0) begin
      d_out <= 16'h0000;
      mem[0] <= 16'd0035;
      mem[1] <= 16'h0000;
      mem[2] <= 16'h0000;
      mem[3] <= 16'h0000;
    end else if (reset == 0) begin
      d_out <= 16'h0000;
      mem[0] <= 16'd0035;
      mem[1] <= 16'h0000;
      mem[2] <= 16'h0000;
      mem[3] <= 16'h0000;
    end else if (start == 1) begin
      d_out <= 16'h0000;
      mem[0] <= d_in;
      mem[1] <= {2'b00, micData};
      mem[2] <= 16'h0002;
      mem[3] <= {wr, rd, cs, addr};
    end else if (cs == 0 && rd == 1 && wr == 0) begin
      d_out <= mem[addr];
    end else begin
      d_out <= 16'h0000;
    end
  end

endmodule