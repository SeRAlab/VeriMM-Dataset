module top_module(
    input [3:0] binary,
    output reg [3:0] abs_val
);always @(*) begin
        if (binary[3] == 1) begin
            abs_val = ~binary + 1;
        end else begin
            abs_val = binary;
        end
    end

endmodule