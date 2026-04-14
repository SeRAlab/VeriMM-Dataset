module comparator_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg less_than,
    output reg equal_to,
    output reg greater_than
);

always @(*) begin
    if (A < B) begin
        less_than = 1;
        equal_to = 0;
        greater_than = 0;
    end
    else if (A == B) begin
        less_than = 0;
        equal_to = 1;
        greater_than = 0;
    end
    else begin
        less_than = 0;
        equal_to = 0;
        greater_than = 1;
    end
end

endmodule