module top_module(
    input [3:0] A,
    input [3:0] B,
    input M,
    output reg [3:0] S,
    output reg V
);always @(*) begin
        if (M == 0) begin
            S = A + B;
            if (S > 15) begin
                V = 1;
            end else begin
                V = 0;
            end
        end else begin
            S = A - B;
            if (S < 0) begin
                V = 1;
            end else begin
                V = 0;
            end
        end
    end

endmodule