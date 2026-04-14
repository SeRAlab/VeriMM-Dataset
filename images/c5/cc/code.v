module max_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] max_val
);

    always @* begin
        if (A > B)
            max_val = A;
        else
            max_val = B;
    end

endmodule