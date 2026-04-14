module top_module(
  input clk,
  input reset,
  input [1:0] sel,
  output reg [3:0] bcd
);reg [3:0] counter1 = 4'b0000;
  reg [2:0] counter2 = 3'b000;
  wire [3:0] binary_out;

  // Counter 1
  always @(posedge clk) begin
    if (reset) begin
      counter1 <= 4'b0000;
    end else begin
      if (counter1 == 4'b1001) begin
        counter1 <= 4'b0000;
      end else begin
        counter1 <= counter1 + 1;
      end
    end
  end

  // Counter 2
  always @(posedge clk) begin
    if (reset) begin
      counter2 <= 3'b000;
    end else begin
      if (counter2 == 3'b101) begin // Corrected size for comparison
        counter2 <= 3'b000;
      end else begin
        counter2 <= counter2 + 1;
      end
    end
  end

  // Multiplexer
  assign binary_out = (sel == 2'b00) ? counter1 : {1'b0, counter2}; // Ensure 4-bit width for binary_out

  // BCD conversion
  always @(*) begin
    case (binary_out)
      4'b0000: bcd = 4'b0000;
      4'b0001: bcd = 4'b0001;
      4'b0010: bcd = 4'b0010;
      4'b0011: bcd = 4'b0011;
      4'b0100: bcd = 4'b0100;
      4'b0101: bcd = 4'b0101;
      4'b0110: bcd = 4'b0110;
      4'b0111: bcd = 4'b0111;
      4'b1000: bcd = 4'b1000;
      4'b1001: bcd = 4'b1001;
      default: bcd = 4'b0000;
    endcase
  end

endmodule