module add_subtract(
    input [7:0] A,
    input [7:0] B,
    input C,
    output reg [7:0] out
);

always @(*) begin
    if(C) begin
        out = A + B;
    end else begin
        out = A - B;
    end
end

endmodule