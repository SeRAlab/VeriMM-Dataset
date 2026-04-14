module top_module(
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    output reg X,
    output reg Y
);always @(*) begin
    if (A) begin
        X = 1'b1;
        Y = 1'b0;
    end else begin
        if (B || (C && !D)) begin
            X = 1'b1;
        end else begin
            X = 1'b0;
        end
        if (!B || (C && D)) begin
            Y = 1'b1;
        end else begin
            Y = 1'b0;
        end
    end
end

endmodule