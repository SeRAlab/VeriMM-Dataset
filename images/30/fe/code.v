module LIFO_Stack (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    output reg empty,
    output reg full
);
    reg [3:0] stack [7:0];
    reg [2:0] sp; // Stack pointer

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 3'b000;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (push && !full) begin
                stack[sp] <= data_in;
                sp <= sp + 1;
                empty <= 1'b0;
                if (sp == 3'd6) full <= 1'b1; // Stack is full
            end
            if (pop && !empty) begin
                sp <= sp - 1;
                data_out <= stack[sp];
                if (sp == 3'b001) empty <= 1'b1; // Stack is empty
                full <= 1'b0;
            end
        end
    end
endmodule