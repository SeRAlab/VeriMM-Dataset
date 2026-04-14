module top_module(
    input   [3:0]  input_data,
    output  reg     output_data  // Change wire to reg because it is assigned in always block
);always @(*) begin
        if (input_data == 4'b1010) begin
            output_data = 1'b1;  // Use 1'b1 for clarity
        end else begin
            output_data = 1'b0;  // Use 1'b0 for clarity
        end
    end

endmodule