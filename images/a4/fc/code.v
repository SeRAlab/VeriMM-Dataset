module top_module(
    input [3:0] a, 
    input [3:0] b, 
    input [1:0] op, 
    output reg [3:0] add_out, 
    output reg [3:0] sub_out, 
    output reg [3:0] mul_out, 
    output reg [3:0] div_out
);wire [7:0] prod;
  
  assign prod = a * b;

  always @(*) begin
    case(op)
      2'b00: begin
        add_out = a + b;
        sub_out = 4'h0; // Zero the outputs that are not used
        mul_out = 4'h0; 
        div_out = 4'h0;
      end
      2'b01: begin
        sub_out = a - b;
        add_out = 4'h0; // Zero the outputs that are not used
        mul_out = 4'h0; 
        div_out = 4'h0;
      end
      2'b10: begin
        mul_out = prod[7:4]; // Taking the higher bits
        add_out = 4'h0; // Zero the outputs that are not used
        sub_out = 4'h0; 
        div_out = 4'h0;
      end
      2'b11: begin
        div_out = (b == 4'h0) ? 4'h0 : a / b;
        add_out = 4'h0; // Zero the outputs that are not used
        sub_out = 4'h0; 
        mul_out = 4'h0;
      end
      default: begin
        add_out = 4'h0; // Handling default case
        sub_out = 4'h0; 
        mul_out = 4'h0; 
        div_out = 4'h0;
      end
    endcase
  end

endmodule