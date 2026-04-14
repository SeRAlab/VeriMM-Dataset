module top_module(din, clk, rst, load, q);parameter SIZE = 4; // counter size

  input clk, rst, load;
  input [SIZE-1:0] din;
  output [SIZE-1:0] q;

  reg [SIZE-1:0] q_next; // next value of counter
  reg [SIZE-1:0] q_reg; // current value of counter

  always @ (posedge clk) begin
    if (rst) begin // reset
      q_reg <= 0;
    end else if (load) begin // load
      q_reg <= din;
    end else begin // increment
      q_reg <= q_next;
    end
  end

  always @ (*) begin
    q_next = q_reg + 1;
  end

  assign q = q_reg;
endmodule