module LIFO_Stack #(parameter SIZE = 8, parameter WIDTH = 8) (
    input clk,
    input rst,
    input [WIDTH-1:0] data_in,
    input push,
    input pop,
    output reg [WIDTH-1:0] top,
    output reg empty,
    output reg full
);
    reg [WIDTH-1:0] stack [0:SIZE-1];
    reg [3:0] ptr; // Points to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ptr <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (push && !full) begin
                stack[ptr] <= data_in;
                ptr <= ptr + 1;
                empty <= 0;
                if (ptr + 1 == SIZE) begin
                    full <= 1;
                end
            end
            if (pop && !empty) begin
                ptr <= ptr - 1;
                top <= stack[ptr - 1];
                if (ptr - 1 == 0) begin
                    empty <= 1;
                end
                full <= 0;
            end
            if (ptr > 0) begin
                top <= stack[ptr - 1];
            end
        end
    end
endmodule