module comparator_2bit(
    input [1:0] A,
    input [1:0] B,
    output reg greater,
    output reg less,
    output reg equal
);
    always @(*) begin
        greater = 0;
        less = 0;
        equal = 0;
        
        if (A > B) begin
            greater = 1;
        end else if (A < B) begin
            less = 1;
        end else begin
            equal = 1;
        end
    end
endmodule