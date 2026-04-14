module top_module(a, d, clk, we, spo);input [9:0] a;
  input [15:0] d;
  input clk;
  input we;
  output reg [15:0] spo;  // Change to reg since we need to assign values inside an always block

  reg [15:0] stack [0:1023];
  reg [9:0] sp;

  always @ (posedge clk) begin
    if (we) begin
      if (sp < 1024) begin
        stack[sp] <= d;
        sp <= sp + 1;
      end else begin
        $display("Error: Stack full");
      end
    end else begin
      if (sp > 0) begin
        sp <= sp - 1;
        spo <= stack[sp];
      end else begin
        $display("Error: Stack empty");
      end
    end
  end

endmodule