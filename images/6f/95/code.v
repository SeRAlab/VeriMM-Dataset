module top_module(input [3:0] in, input en, output out);reg [1:0] sel;
  always @(*) begin
    if (en) begin
      case(in)
        4'b0001: sel = 2'b00;
        4'b0010: sel = 2'b01;
        4'b0100: sel = 2'b10;
        4'b1000: sel = 2'b11;
        default: sel = 2'b00;
      endcase
    end
    else begin
      sel = 2'b00;
    end
  end

  assign out = {in[sel], 1'b0};

endmodule