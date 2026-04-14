module top_module(
    input  [4:0] current_test,
    output [22:0] data
);assign data = (current_test[1:0] == 2'b00) ? 23'h7ABCDE :
              (current_test[1:0] == 2'b01) ? 23'h712345 :
              (current_test[1:0] == 2'b10) ? 23'h767890 : 23'h7BBCCD ;



  










endmodule