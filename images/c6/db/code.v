module mux_2to1_priority (
    input [3:0] A,
    input [3:0] B,
    input P,
    output reg [3:0] Y
);

always @(*) begin
    if (P) begin
        Y <= A;
    end else begin
        Y <= B;
    end
end

endmodule