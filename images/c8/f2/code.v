module calculator(input signed [31:0] a, input signed [31:0] b, input op, output reg signed [31:0] result);

always @(*) begin
    if(op == 0) begin
        result = a + b;
    end else begin
        result = a - b;
    end
end

endmodule