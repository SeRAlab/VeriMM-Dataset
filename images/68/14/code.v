module top_module(
    input [7:0] denom,
    input [7:0] numer,
    output reg [7:0] quotient,
    output reg [7:0] remain
);always @(*) begin
        if (denom != 0) begin
            quotient = numer / denom;
            remain = numer % denom;
        end else begin
            quotient = 0;    // Handle division by zero case
            remain = 0;
        end
    end

endmodule