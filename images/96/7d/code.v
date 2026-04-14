module top_module(
    input [2:0] in,
    output reg [6:0] out
  );always @* begin
    
    case (in)
      1'h0: begin
        out = 7'h01;
      end
      1'h1: begin
        out = 7'h02;
      end
      2'h2: begin
        out = 7'h04;
      end
      2'h3: begin
        out = 7'h08;
      end
      3'h4: begin
        out = 7'h10;
      end
      3'h5: begin
        out = 7'h20;
      end
      3'h6: begin
        out = 7'h40;
      end
      default: begin
        out = 7'h00;
      end
    endcase
  end
endmodule