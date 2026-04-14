module top_module(
  input clk,
  input reset_n,
  input [31:0] in_data,
  input [2:0] op_select, // Changed to 3 bits to accommodate all operations
  input enable,
  output reg [31:0] out_data
);always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      out_data <= 0;
    end else if (enable) begin
      case (op_select)
        3'b000: out_data <= in_data & in_data; // AND
        3'b001: out_data <= in_data | in_data; // OR
        3'b010: out_data <= in_data ^ in_data; // XOR
        3'b011: out_data <= ~in_data; // NOT
        3'b100: out_data <= in_data + in_data; // Addition
        3'b101: out_data <= in_data - in_data; // Subtraction
        3'b110: out_data <= in_data * in_data; // Multiplication
        3'b111: out_data <= in_data / in_data; // Division
        default: out_data <= 0;
      endcase
    end
  end

endmodule