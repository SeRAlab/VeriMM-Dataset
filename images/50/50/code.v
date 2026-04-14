module top_module(
  input      [15:0] lin,
  output reg [9:0] man,
  output reg [2:0] exp
);always @(*) begin
  casex( lin[15:9] )
    
    7'b10XXXXX: begin
        man = lin[15:6];
        exp = 3'd7;
      end
    7'b110XXXX: begin
        man = lin[14:5];
        exp = 3'd6;
      end
    7'b1110XXX: begin
        man = lin[13:4];
        exp = 3'd5;
      end
    7'b11110XX: begin
        man = lin[12:3];
        exp = 3'd4;
      end
    7'b111110X: begin
        man = lin[11:2];
        exp = 3'd3;
      end
    7'b1111110: begin
        man = lin[10:1];
        exp = 3'd2;
      end
    7'b1111111: begin
        man = lin[ 9:0];
        exp = 3'd1;
      end    
    
    7'b01XXXXX: begin
        man = lin[15:6];
        exp = 3'd7;
      end
    7'b001XXXX: begin
        man = lin[14:5];
        exp = 3'd6;
      end
    7'b0001XXX: begin
        man = lin[13:4];
        exp = 3'd5;
      end
    7'b00001XX: begin
        man = lin[12:3];
        exp = 3'd4;
      end
    7'b000001X: begin
        man = lin[11:2];
        exp = 3'd3;
      end
    7'b0000001: begin
        man = lin[10:1];
        exp = 3'd2;
      end
    7'b0000000: begin
        man = lin[ 9:0];
        exp = 3'd1;
      end
    
    default: begin
        man = lin[9:0];
        exp = 3'd1;
      end
  endcase
end

endmodule