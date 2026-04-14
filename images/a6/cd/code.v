module top_module(
    input A,
    input B,
    input C,
    input EN,
    output reg Z
);always @ (A or B or C or EN) begin
    if (EN) begin
        Z <= A;
    end else begin
        if (B) begin
            Z <= B;
        end else begin
            Z <= C;
        end
    end
end

endmodule