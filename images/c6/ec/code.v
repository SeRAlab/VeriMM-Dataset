module mux2to1(input a, input b, input s, output reg out);

always @(*) begin
    if (s == 0) begin
        out = a;
    end else begin
        out = b;
    end
end

endmodule