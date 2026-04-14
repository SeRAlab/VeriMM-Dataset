module stack(
    input clk,
    input rst,
    input [3:0] data_in,
    input push,
    input pop,
    output reg [3:0] top,
    output reg is_empty
);
    reg [3:0] stack_mem [0:7];
    reg [2:0] stack_ptr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stack_ptr <= 3'b000;
            is_empty <= 1'b1;
        end else begin
            if (push && stack_ptr < 3'b111) begin
                stack_mem[stack_ptr] <= data_in;
                stack_ptr <= stack_ptr + 1;
                is_empty <= 1'b0;
            end
            if (pop && stack_ptr > 3'b000) begin
                stack_ptr <= stack_ptr - 1;
            end
            if (stack_ptr > 0) begin
                top <= stack_mem[stack_ptr - 1];
            end else begin
                top <= 4'b0000; // return 0 when empty
                is_empty <= 1'b1;
            end
        end
    end
endmodule