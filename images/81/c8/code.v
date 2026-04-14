module top_module(
  input clk,
  input [3:0] binary,
  output reg [3:0] gray
);reg [3:0] state;

  always @(posedge clk) begin
    case(state)
      4'b0000: state <= binary;
      4'b0001: state <= binary ^ 4'b0011;
      4'b0010: state <= binary ^ 4'b0010;
      4'b0011: state <= binary ^ 4'b0001;
      4'b0100: state <= binary ^ 4'b0100;
      4'b0101: state <= binary ^ 4'b0110;
      4'b0110: state <= binary ^ 4'b0101;
      4'b0111: state <= binary ^ 4'b0111;
      4'b1000: state <= binary ^ 4'b1000;
      4'b1001: state <= binary ^ 4'b1010;
      4'b1010: state <= binary ^ 4'b1001;
      4'b1011: state <= binary ^ 4'b1011;
      4'b1100: state <= binary ^ 4'b1101;
      4'b1101: state <= binary ^ 4'b1111;
      4'b1110: state <= binary ^ 4'b1100;
      4'b1111: state <= binary;
    endcase
  end

  always @(*) begin
    case(state)
      4'b0000: gray = 4'b0000;
      4'b0001: gray = 4'b0001;
      4'b0010: gray = 4'b0011;
      4'b0011: gray = 4'b0010;
      4'b0100: gray = 4'b0110;
      4'b0101: gray = 4'b0111;
      4'b0110: gray = 4'b0101;
      4'b0111: gray = 4'b0100;
      4'b1000: gray = 4'b1100;
      4'b1001: gray = 4'b1101;
      4'b1010: gray = 4'b1111;
      4'b1011: gray = 4'b1110;
      4'b1100: gray = 4'b1010;
      4'b1101: gray = 4'b1011;
      4'b1110: gray = 4'b1001;
      4'b1111: gray = 4'b1000;
    endcase
  end

endmodule