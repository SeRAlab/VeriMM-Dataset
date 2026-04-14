module top_module(
    input wire a,
    input wire b,
    input wire c,
    output reg q
    );always @* begin
    if (a == 1) begin
        q = 1;
    end else if (a == 0 && b == 1) begin
        q = 0;
    end else if (a == 0 && b == 0 && c == 0) begin
        q = 1;
    end else begin
        q = c;
    end
end

endmodule