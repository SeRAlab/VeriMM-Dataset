module adder_subtractor (
    input [3:0] in0,
    input [3:0] in1,
    input SUB,
    output reg [3:0] out
);

    always @(*) begin
        if (SUB) begin
            out <= in0 - in1;
        end else begin
            out <= in0 + in1;
        end
    end

endmodule