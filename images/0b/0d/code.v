module LIFO_Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    parameter STACK_DEPTH = 4;
    reg [7:0] stack [0:STACK_DEPTH-1];
    reg [1:0] sp; // stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (push && !full) begin
                stack[sp] <= data_in;
                sp <= sp + 1;
                empty <= 0;
                if (sp + 1 == STACK_DEPTH) full <= 1;
            end
            if (pop && !empty) begin
                sp <= sp - 1;
                data_out <= stack[sp - 1];
                full <= 0;
                if (sp - 1 == 0) empty <= 1;
            end
        end
    end
endmodule