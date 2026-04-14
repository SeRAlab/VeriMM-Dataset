module and_en(
    input [2:0] a, b, c,
    input en,
    output y
);

    wire [2:0] and_result;
    assign and_result = a & b & c;
    
    assign y = en ? and_result[0] & and_result[1] & and_result[2] : 1'b0;

endmodule