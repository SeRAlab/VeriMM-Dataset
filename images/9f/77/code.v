module top_module(
                  input [3:0] sel,
                  output reg [7:0] out  // Change 'output' to 'output reg'
                 );always @*
    begin : sel_to_out_logic
      case(sel)
        4'b0000: out = 8'b00000000;
        4'b0001: out = 8'b00000001;
        4'b0010: out = 8'b00000010;
        4'b0011: out = 8'b00000011;
        4'b0100: out = 8'b00000100;
        4'b0101: out = 8'b00000101;
        4'b0110: out = 8'b00000110;
        4'b0111: out = 8'b00000111;
        4'b1000: out = 8'b11111000;
        4'b1001: out = 8'b11111001;
        4'b1010: out = 8'b11111010;
        4'b1011: out = 8'b11111011;
        4'b1100: out = 8'b11111100;
        4'b1101: out = 8'b11111101;
        4'b1110: out = 8'b11111110;
        4'b1111: out = 8'b11111111;
        default: out = 8'b00000000; // Add default case for safety
      endcase // case(sel)
    end // block: sel_to_out_logic
endmodule