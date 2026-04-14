module top_module(
    input signed [15:0] number,
    output reg [15:0] abs_value
);always @* begin
        if (number < 0) begin
            abs_value <= ~number + 1;
        end
        else begin
            abs_value <= number;
        end
    end

endmodule