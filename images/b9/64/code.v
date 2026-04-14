module top_module(
  input                clk,
  input                rst_n,
  input                select,
  output reg  [63:0]   Q
);reg [63:0] shift_reg;
  reg [3:0]  counter;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      shift_reg <= 64'b0;
      counter <= 4'b0;
      Q <= 64'b0;
    end
    else begin
      if (select) begin
        // Johnson counter
        case (counter)
          4'b0000: shift_reg <= 64'b0001;
          4'b0001: shift_reg <= 64'b0011;
          4'b0011: shift_reg <= 64'b0111;
          4'b0111: shift_reg <= 64'b1111;
          4'b1111: shift_reg <= 64'b1110;
          4'b1110: shift_reg <= 64'b1100;
          4'b1100: shift_reg <= 64'b1000;
          4'b1000: shift_reg <= 64'b0000;
        endcase
        counter <= counter + 1;
      end
      else begin
        // Shift register
        shift_reg <= {shift_reg[62:0], shift_reg[63]};
      end
      Q <= select ? shift_reg : {64{1'b0}};
    end
  end

endmodule