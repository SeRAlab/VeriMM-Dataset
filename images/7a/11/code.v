module top_module(
    input clk,
    input load,
    input [31:0] data_in,
    output reg [31:0] data_out
);parameter len = 8;

    reg [31:0] shift_reg [len-1:0];
    integer i;

    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < len; i = i + 1) begin
                shift_reg[i] <= data_in;
            end
        end else begin
            for (i = len-1; i > 0; i = i - 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            shift_reg[0] <= data_out;
        end
    end

    assign data_out = shift_reg[len-1];

endmodule