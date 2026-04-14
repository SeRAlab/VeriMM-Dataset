module top_module(
    input A1,
    input A2,
    input B1,
    output reg X
);always @ (A1, A2, B1)
    begin
        if (A1 == 1 && A2 == 1 && B1 == 1) begin
            X <= 1;
        end
        else begin
            X <= 0;
        end
    end

endmodule