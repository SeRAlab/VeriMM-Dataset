module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg X
);always @(*) begin
        if (A && !B) begin
            X = 1;
        end else if (C && !D) begin
            X = 0;
        end else begin
            X = (A || B || C || D) ? 1 : 0;
        end
    end

endmodule