module top_module(input wire [7:0] A_in,
              input wire [7:0] B_in,
              input wire       C_in,
              input wire [2:0] Opcode_in,
              output reg [7:0] Result_out,
              output reg       C_out);always @ ( * ) begin
    case (Opcode_in)
      3'b000: // A+B+Cin
              begin
                // perform addition with carry in
                {C_out, Result_out} = A_in + B_in + C_in;
              end
      3'b001: // A-B
              begin
                // perform subtraction
                Result_out = A_in - B_in;
                C_out = (A_in < B_in) ? 1 : 0; // set carry out if A_in < B_in
              end
      3'b010: // A & B
              begin
                // perform bitwise AND
                Result_out = A_in & B_in;
                C_out = 0; // no carry out for bitwise AND
              end
      3'b011: // A|B
              begin
                // perform bitwise OR
                Result_out = A_in | B_in;
                C_out = 0; // no carry out for bitwise OR
              end
      3'b100: // A % B
              begin
                // perform modulo operation
                Result_out = A_in % B_in;
                C_out = 0; // no carry out for modulo operation
              end
      default:
              begin
                // default case: set result to 0
                Result_out = 8'b0;
                C_out = 0;
              end
    endcase
  end
endmodule