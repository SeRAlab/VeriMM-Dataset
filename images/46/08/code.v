module top_module(
  input signed [15:0] x,
  input signed [15:0] y,
  input [7:0] s_x,
  input [7:0] s_y,
  output reg signed [31:0] z,
  output reg [7:0] s_z
);// Inputs:
// x: first fixed-point number
// y: second fixed-point number
// s_x: scaling factor for x
// s_y: scaling factor for y

// Outputs:
// z: result of arithmetic operation
// s_z: scaling factor for z

always @(*) begin
    // Initialize the output
    z = 0;
    s_z = 0;

    // Addition
    z = (x << s_x) + (y << s_y);
    s_z = (s_x > s_y) ? s_x : s_y;

    // Subtraction
    z = (x << s_x) - (y << s_y);
    s_z = (s_x > s_y) ? s_x : s_y;

    // Multiplication
    z = (x * y) >> (s_x + s_y);
    s_z = s_x + s_y;

    // Division
    z = (x << (s_x + 16)) / y;
    s_z = s_x - s_y - 16;
end

endmodule