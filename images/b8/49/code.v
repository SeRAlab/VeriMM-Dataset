module top_module(
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [3:0] result,
    output overflow
);reg signed [3:0] temp_result;
reg overflow_reg; // Changed to a different name

always @(*) begin
    temp_result = a + b;
    if ((a[3] == 1 && b[3] == 1 && temp_result[3] == 0) || (a[3] == 0 && b[3] == 0 && temp_result[3] == 1)) begin
        overflow_reg = 1;
    end else begin
        overflow_reg = 0;
    end
end

assign result = temp_result;
assign overflow = overflow_reg; // Assigning the register to the output

endmodule