module top_module(
    input [15:0] input_val,
    output reg [3:0] output_val
);always @(*) begin
    if (input_val <= 16'h7FFF) begin
        output_val = input_val[15:12];
    end else begin
        output_val = input_val[3:0];
    end
end

endmodule