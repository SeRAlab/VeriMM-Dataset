module top_module(
    input  clk,
    input  io_valid_0,
    input  io_ready,
    input  [2:0] io_poly,
    output reg [2:0] io_encoded   // Changed output to reg type
);reg [2:0] shift_reg;
  reg [2:0] poly;               // Changed poly to reg type
  
  always @(*) begin
    case (io_poly)
      3'b001: poly = 3'b101;
      3'b010: poly = 3'b011;
      3'b100: poly = 3'b111;
      default: poly = 3'b000;
    endcase
  end
  
  always @(posedge clk) begin
    if (io_ready) begin
      shift_reg <= {shift_reg[1:0], io_valid_0};
    end
  end
  
  wire [2:0] poly_shifted;
  assign poly_shifted = {poly[1:0], 1'b0};
  
  wire [2:0] mult_0;
  assign mult_0 = shift_reg ^ poly_shifted;
  
  wire [2:0] mult_1;
  assign mult_1 = {mult_0[1:0], 1'b0} ^ poly_shifted;
  
  wire [2:0] mult_2;
  assign mult_2 = {mult_1[1:0], 1'b0} ^ poly_shifted;
  
  always @(*) begin
    io_encoded = {mult_2[0], mult_1[0], mult_0[0]};  // Changed to assign in always block
  end
  
endmodule