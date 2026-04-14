module LIFO_Stack (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire push,
    input wire pop,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] stack[0:3]; // Stack of size 4
    reg [1:0] top; // Points to the top of the stack

    initial begin
        top = 0;
        full = 0;
        empty = 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
                empty <= 0;
                if (top == 3) full <= 1;
            end
            
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top];
                full <= 0;
                if (top == 1) empty <= 1;
            end
        end
    end
endmodule