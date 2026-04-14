module LIFO_Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] stack [0:7];
    reg [2:0] sp; // stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 0;
        end else begin
            if (push && !full) begin
                stack[sp] <= data_in;
                sp <= sp + 1;
            end
            if (pop && !empty) begin
                sp <= sp - 1;
                data_out <= stack[sp];
            end
            full <= (sp == 8);
            empty <= (sp == 0);
        end
    end
endmodule