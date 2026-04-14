module top_module(
    input[4:0] inA,
    input[4:0] inB,
    input[0:0] sel,
    output reg[4:0] out
);always @* begin
        if (sel==1'b0) begin
            out <= inA;
        end else begin
            out <= inB;
        end
    end

endmodule