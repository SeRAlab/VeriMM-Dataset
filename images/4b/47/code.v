module top_module(
    input [2:0] rm,
    input [1:0] mod,
    input [2:0] sovr_pr,

    output reg [3:0] base,
    output reg [3:0] index,
    output     [1:0] seg
  );reg [1:0] s;

  
  assign seg = sovr_pr[2] ? sovr_pr[1:0] : s;

  
  always @(rm or mod)
    case (rm)
      3'b000: begin base <= 4'b0011; index <= 4'b0110; s <= 2'b11; end
      3'b001: begin base <= 4'b0011; index <= 4'b0111; s <= 2'b11; end
      3'b010: begin base <= 4'b0101; index <= 4'b0110; s <= 2'b10; end
      3'b011: begin base <= 4'b0101; index <= 4'b0111; s <= 2'b10; end
      3'b100: begin base <= 4'b1100; index <= 4'b0110; s <= 2'b11; end
      3'b101: begin base <= 4'b1100; index <= 4'b0111; s <= 2'b11; end
      3'b110: begin base <= mod ? 4'b0101 : 4'b1100; index <= 4'b1100;
                    s <= mod ? 2'b10 : 2'b11; end
      3'b111: begin base <= 4'b0011; index <= 4'b1100; s <= 2'b11; end
    endcase
endmodule