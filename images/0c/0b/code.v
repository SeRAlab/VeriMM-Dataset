module stack (
    input clk,
    input reset,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    parameter STACK_SIZE = 8;
    reg [7:0] stack_mem [0:STACK_SIZE-1];
    reg [3:0] top;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 4'b1111; // Stack is empty
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (push && !full) begin
                top <= top - 1;
                stack_mem[top] <= data_in;
                empty <= 1'b0;
                if (top == 4'b0000) full <= 1'b1;
            end
            if (pop && !empty) begin
                data_out <= stack_mem[top];
                top <= top + 1;
                full <= 1'b0;
                if (top == 4'b1110) empty <= 1'b1;
            end
        end
    end
endmodule