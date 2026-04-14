module top_module(SW, LEDG, LEDR, HEX0, CLK);input [4:0] SW;
  input CLK;
  output reg [0:0] LEDG, LEDR;
  output reg [6:0] HEX0;

  wire [3:0] sw_hex;
  wire is_even;

  assign is_even = ~SW[0];

  assign LEDG = is_even;
  assign LEDR = ~is_even;

  assign sw_hex = (SW[4]) ? 4'b1000 :
                  (SW[3]) ? 4'b0100 :
                  (SW[2]) ? 4'b0010 :
                  (SW[1]) ? 4'b0001 :
                            4'b0000 ;

  // Removed the instantiation of an unknown module "inicial"
  // instantiate any other necessary modules here if needed

  always @(posedge CLK) begin
    if (SW == 5'b00000) begin
      HEX0 <= 7'b0000000;
    end else begin
      case (sw_hex)
        4'b0000: HEX0 <= 7'b0000001;
        4'b0001: HEX0 <= 7'b0000010;
        4'b0010: HEX0 <= 7'b0000100;
        4'b0011: HEX0 <= 7'b0000110;
        4'b0100: HEX0 <= 7'b0001000;
        4'b0101: HEX0 <= 7'b0001010;
        4'b0110: HEX0 <= 7'b0001100;
        4'b0111: HEX0 <= 7'b0001110;
        4'b1000: HEX0 <= 7'b0010000;
        4'b1001: HEX0 <= 7'b0010010;
        4'b1010: HEX0 <= 7'b0010100;
        4'b1011: HEX0 <= 7'b0010110;
        4'b1100: HEX0 <= 7'b0011000;
        4'b1101: HEX0 <= 7'b0011010;
        4'b1110: HEX0 <= 7'b0011100;
        4'b1111: HEX0 <= 7'b0011110;
      endcase
    end
  end
endmodule