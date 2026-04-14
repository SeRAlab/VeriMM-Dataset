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
    reg [7:0] stack_mem [7:0]; // 8 elements stack
    reg [3:0] top; // points to the current top of the stack

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
            end
            full <= (top == 8);
            empty <= (top == 0);
        end
    end
endmodule