module top_module(
  input wire clk,           // Added clk input
  input wire [3:0] a,
  input wire [3:0] b,
  input wire [7:0] c,
  output reg [8:0] y
);reg [15:0] count;
  reg [3:0] a_val, b_val;
  reg [7:0] c_val;
  reg [11:0] mult_val;
  reg [16:0] add_val;

  always @(posedge clk)
  begin
    a_val = a;              // Use input 'a' instead of count
    b_val = b;              // Use input 'b' instead of count
    c_val = c;              // Use input 'c' instead of count

    mult_val = a_val * b_val;
    add_val = mult_val + c_val + y;
    y <= add_val[8:0];
    
    count <= count + 1;
  end

endmodule