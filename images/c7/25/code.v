module subtractor (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Y
);

    always @ (A or B) begin
        Y <= A - B;
    end

endmodule