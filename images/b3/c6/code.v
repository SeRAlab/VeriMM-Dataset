module top_module(A, B, S, Y);input A, B, S;
output reg Y; // Changed to reg type

always @(*) begin
    Y = (!S & A) | (S & B);
end

endmodule