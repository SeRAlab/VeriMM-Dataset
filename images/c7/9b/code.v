module greater_than_module (
   input [3:0] a,
   input [3:0] b,
   output reg [3:0] x
);

always @(*) begin
    if (a > b) begin
        x = a;
    end else begin
        x = b;
    end
end

endmodule