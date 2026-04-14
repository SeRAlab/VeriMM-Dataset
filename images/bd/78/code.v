module top_module(input bit0, bit1, cin,
                  output sum, cout);assign sum = bit0^bit1^cin;
    assign cout = (bit0&bit1)|(bit0&cin)|(bit1&cin);endmodule