module top_module(
  input clk,
  input reset,
  output reg [2:0] gray_out,
  output reg max_reached // Change output to reg
);reg [2:0] binary_out;
reg [2:0] prev_binary_out;

always @(posedge clk or negedge reset) begin
  if (reset == 0) begin
    binary_out <= 0;
    prev_binary_out <= 0;
    gray_out <= 0;
    max_reached <= 0;
  end else begin
    binary_out <= prev_binary_out + 1;
    prev_binary_out <= binary_out;
    case (binary_out)
      3'd0: gray_out <= 3'b000;
      3'd1: gray_out <= 3'b001;
      3'd2: gray_out <= 3'b011;
      3'd3: gray_out <= 3'b010;
      3'd4: gray_out <= 3'b110;
      3'd5: gray_out <= 3'b111;
      3'd6: begin
        gray_out <= 3'b101;
        max_reached <= 1;
      end
      default: gray_out <= 3'b000;
    endcase
  end
end

endmodule