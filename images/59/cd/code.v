module top_module(
    input[25:0] in1,
    output reg[31:0] out );always @(*) begin
        out <= {6'b000000, in1};
    end

endmodule