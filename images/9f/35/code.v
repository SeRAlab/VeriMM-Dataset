module top_module(
    OUT,
    A,
    B,
    EN
);output reg [7:0] OUT;
    input [7:0] A;
    input [7:0] B;
    input EN;

    always @(*) begin
        if (EN) begin
            OUT = A ^ B;
        end
        else begin
            OUT = 8'b0;
        end
    end

endmodule