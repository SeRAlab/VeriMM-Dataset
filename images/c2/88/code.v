module xor_gate(input a, b, c, output out);

  assign out = (a ^ b) ^ c;

  always @ (a, b, c)
    begin
      out = (a ^ b) ^ c;
    end

endmodule