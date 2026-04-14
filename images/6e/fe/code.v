module top_module(
  input [3:0] in,
  input [1:0] ctrl,
  output reg [1:0] out
);always @ (in or ctrl) begin
    if (ctrl == 2'b00) begin
      case (in)
        4'b0001: out = 2'b00;
        4'b0010: out = 2'b01;
        4'b0100: out = 2'b10;
        4'b1000: out = 2'b11;
        default: out = 2'b00;
      endcase
    end else if (ctrl == 2'b01) begin
      case (in)
        4'b0001: out = 2'b00;
        4'b0010: out = 2'b00;
        4'b0100: out = 2'b01;
        4'b1000: out = 2'b10;
        default: out = 2'b00;
      endcase
    end else if (ctrl == 2'b10) begin
      case (in)
        4'b0001: out = 2'b00;
        4'b0010: out = 2'b00;
        4'b0100: out = 2'b00;
        4'b1000: out = 2'b01;
        default: out = 2'b00;
      endcase
    end else begin // ctrl == 2'b11
      case (in)
        4'b0001: out = 2'b00;
        4'b0010: out = 2'b00;
        4'b0100: out = 2'b00;
        4'b1000: out = 2'b00;
        default: out = 2'b00;
      endcase
    end
  end

endmodule