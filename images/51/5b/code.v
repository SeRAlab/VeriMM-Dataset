module top_module(Q, CLK, RST, LOAD, D);output [3:0] Q;
  input CLK, RST, LOAD;
  input [3:0] D;

  reg [3:0] count;

  always @(posedge CLK) begin
    if (RST) begin
      count <= 4'b0000;
    end
    else if (LOAD) begin
      count <= D;
    end
    else begin
      count <= count + 1;
    end
  end

  assign Q = count;

endmodule