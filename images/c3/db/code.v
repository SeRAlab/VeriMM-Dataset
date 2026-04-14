module max_value (input [7:0] A, B, C, D, output reg [15:0] out);

reg [7:0] max_val;

always @ (A, B, C, D) begin
    max_val = A > B ? A : B;
    max_val = max_val > C ? max_val : C;
    max_val = max_val > D ? max_val : D;
    out = {max_val, 8'b0};
end

endmodule