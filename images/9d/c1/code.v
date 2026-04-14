module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);always @(*) begin
        if (a[7] == 1 && b[7] == 1) begin // both inputs are negative
            result = ~(a*b) + 1;
        end else if (a[7] == 0 && b[7] == 0) begin // both inputs are positive
            result = a*b;
        end else begin // inputs have different signs
            result = -(a*b);
        end
    end

endmodule