module ascending_order (
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    output reg Y
);

always @(*) begin
    if(A < B && B < C) begin
        Y = 1;
    end else begin
        Y = 0;
    end
end

endmodule