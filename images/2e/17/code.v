module comparator_32bit (
    input [31:0] a,
    input [31:0] b,
    output reg [1:0] result // 2'b00: equal, 2'b01: a > b, 2'b10: a < b
);

always @(*) begin
    if (a > b) begin
        result = 2'b01; // a > b
    end else if (a < b) begin
        result = 2'b10; // a < b
    end else begin
        result = 2'b00; // a == b
    end
end

endmodule