module top_module(
  input [2:0] op,
  input [7:0] a,
  input [7:0] b,
  input [4:0] reg_addr,
  input reg_write,
  output reg [7:0] result  // Change wire to reg
);reg [7:0] out;
  reg [7:0] neg_b;

  always @(*) begin
    case(op)
      3'b000: out = a + b;
      3'b001: begin
                 neg_b = ~b + 1;
                 out = a + neg_b;
               end
      3'b010: out = a & b;
      3'b011: out = a | b;
      3'b100: out = a ^ b;
      default: out = 8'h00;
    endcase
  end

  always @(posedge reg_write) begin
    if (reg_write) begin
      result <= out;  // Update only once based on out
    end
  end

endmodule