module comparator (
    input [3:0] in0,
    input [3:0] in1,
    output reg [1:0] result
);

always @(*) begin
    if (in0 > in1) begin
        result = 2'b01; // in0 is greater than in1
    end else if (in0 < in1) begin
        result = 2'b10; // in0 is less than in1
    end else begin
        result = 2'b00; // in0 is equal to in1
    end
end

endmodule