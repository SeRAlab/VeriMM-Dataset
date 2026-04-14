module top_module(a, b, a_signed, b_signed, op, cin, sum, cout);parameter WIDTH = 32;

  input [WIDTH-1:0] a;
  input [WIDTH-1:0] b;
  input a_signed;
  input b_signed;
  input [2:0] op;
  input cin;
  output [WIDTH-1:0] sum;
  output cout;

  wire [WIDTH:0] a_ext;
  wire [WIDTH:0] b_ext;
  reg [WIDTH:0] result_ext; // Change to reg type

  assign a_ext = {a_signed ? {a[WIDTH-1]} : {WIDTH{1'b0}}, a};
  assign b_ext = {b_signed ? {b[WIDTH-1]} : {WIDTH{1'b0}}, b};

  always @(*) begin
    case (op)
      3'b000: result_ext = a_ext + b_ext + cin;
      3'b001: result_ext = a_ext - b_ext - cin;
      3'b010: result_ext = a_ext & b_ext; // Use extended values
      3'b011: result_ext = a_ext | b_ext; // Use extended values
      3'b100: result_ext = a_ext ^ b_ext; // Use extended values
      default: result_ext = 0;
    endcase
  end

  assign sum = result_ext[WIDTH-1:0];
  assign cout = result_ext[WIDTH];

endmodule