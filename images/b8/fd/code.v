module top_module(addend1, addend2, lastCarry, sum, carry);input addend1, addend2, lastCarry;
    output sum, carry;
    assign sum = addend1 ^ addend2 ^ lastCarry;
    assign carry = (addend1 && addend2) | (addend1 && lastCarry) | (addend2 && lastCarry);
endmodule