module comparator_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg LT,
    output reg EQ,
    output reg GT
);
    
    always @(*) begin
        if (A < B) begin
            LT = 1'b1;
            EQ = 1'b0;
            GT = 1'b0;
        end else if (A == B) begin
            LT = 1'b0;
            EQ = 1'b1;
            GT = 1'b0;
        end else begin
            LT = 1'b0;
            EQ = 1'b0;
            GT = 1'b1;
        end
    end
endmodule