module top_module(
    input [3:0] A, B,
    input MODE,
    output [3:0] S
);reg [3:0] temp;

    always @(*) begin
        if (MODE == 0) begin
            temp = A + B;
        end else begin
            temp = A - B;
        end
    end

    assign S = temp;

endmodule