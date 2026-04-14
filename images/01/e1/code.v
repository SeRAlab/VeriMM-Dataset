module stack (
    input clk,
    input reset,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    parameter DEPTH = 8; // Define depth of the stack
    reg [7:0] stack_mem [0:DEPTH-1];
    reg [3:0] top; // Points to the index of the top element

    initial begin
        top = 0;
        full = 0;
        empty = 1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
            end

            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
            end

            empty <= (top == 0);
            full <= (top == DEPTH);
        end
    end
endmodule