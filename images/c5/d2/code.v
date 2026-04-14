module adder_4bit(
    input [3:0] A,
    input [3:0] B,
    input sel,
    output [3:0] C
);

    always @(*) begin
        if(sel == 1'b0) begin
            C = A + B;
        end else begin
            C = A & B;
        end
    end

endmodule