module stack_16x32 (
    input clk,
    input reset,
    input push,
    input pop,
    input [31:0] push_data,
    output reg [31:0] pop_data,
    output reg empty,
    output reg full );

reg [31:0] memory [15:0];
reg [4:0] stack_ptr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stack_ptr <= 0;
        empty <= 1;
        full <= 0;
    end else begin
        if (push && !full) begin
            memory[stack_ptr] <= push_data;
            stack_ptr <= stack_ptr + 1;
        end
        if (pop && !empty) begin
            stack_ptr <= stack_ptr - 1;
            pop_data <= memory[stack_ptr];
        end
        empty <= (stack_ptr == 0);
        full <= (stack_ptr == 16);
    end
end

endmodule