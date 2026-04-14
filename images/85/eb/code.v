module top_module(
    input A, B,
    output reg [3:0] Y
);always @* begin
        if (A == 1 && B == 0) begin
            Y = 4'b0001;
        end else if (A == 0 && B == 1) begin
            Y = 4'b0010;
        end else if (A == 1 && B == 1) begin
            Y = 4'b0011;
        end else begin
            Y = 4'b0000;
        end
    end

endmodule