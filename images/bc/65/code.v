module top_module(
  input [2:0] A,
  input [2:0] B,
  input [1:0] sel,
  output reg [1:0] out
);reg [2:0] selA;
  reg [2:0] selB;

  always @* begin
    case(sel)
      2'b00: begin
        selA = A[0];
        selB = B[0];
      end
      2'b01: begin
        selA = A[1];
        selB = B[1];
      end
      2'b10: begin
        selA = A[2];
        selB = B[2];
      end
      2'b11: begin
        selA = 3'b0;
        selB = 3'b0;
      end
    endcase

    if(sel == 2'b11) begin
      out = 2'b11;
    end
    else if(selA > selB) begin
      out = 2'b10;
    end
    else if(selA < selB) begin
      out = 2'b01;
    end
    else begin
      out = 2'b00;
    end
  end

endmodule