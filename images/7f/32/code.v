module top_module(
  input [31:0] in,
  input [1:0] ctrl,
  input [2:0] amt,
  output [31:0] out
);reg [31:0] shifted;

  always @(*) begin
    case(ctrl)
      2'b00: shifted = in << amt; // Logical shift left
      2'b01: shifted = in >> amt; // Logical shift right
      2'b10: begin // Arithmetic shift right
        if(in[31] == 1) begin
          shifted = (in >> amt) | (({32{1'b1}}) << (32 - amt)); // Sign extension
        end else begin
          shifted = in >> amt; // Logical shift right for unsigned values
        end
      end
      default: shifted = 32'h0; // Default case
    endcase
  end

  assign out = shifted;

endmodule