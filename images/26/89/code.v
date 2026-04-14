module LIFO_Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] top,
    output reg empty,
    output reg full
);
    reg [7:0] stack [0:7];
    reg [2:0] sp; // Stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            empty <= 1;
            full <= 0;
            top <= 0;
        end else begin
            if (push && !full) begin
                stack[sp] <= data_in;
                top <= data_in;
                sp <= sp + 1;
                empty <= 0;
                if (sp == 7) full <= 1;
            end
            if (pop && !empty) begin
                sp <= sp - 1;
                if (sp > 0) top <= stack[sp - 1];
                else top <= 0; // Reset top if stack is empty
                if (sp == 1) empty <= 1;
                full <= 0;
            end
        end
    end
endmodule