module top_module(
  input                clk,
  input                rst_n,
  input  [3:0]         load,
  output reg  [3:0]    Q
);reg [63:0] shift_reg;
  reg [3:0]  next_state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      shift_reg <= 64'b0;
      Q <= 4'b0;
    end
    else begin
      shift_reg <= {shift_reg[62:0], shift_reg[63]};
      if (load != 4'b0) begin
        shift_reg <= {32'b0, load};
        Q <= load;
      end
      else begin
        next_state = {shift_reg[62], shift_reg[63], shift_reg[0], shift_reg[1]} + shift_reg[63:0];
        shift_reg <= {shift_reg[62:0], next_state[3]};
        Q <= next_state[3:0];
      end
    end
  end

endmodule