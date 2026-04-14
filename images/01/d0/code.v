module LIFO_stack(
    input clk,
    input reset,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] stack [7:0]; // 8 elements stack
    reg [2:0] top_index; // points to the top of the stack

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top_index <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (push && !full) begin
                stack[top_index] <= data_in;
                top_index <= top_index + 1;
                empty <= 1'b0;
                if (top_index == 3'b111) full <= 1'b1; // Stack is full
            end
            if (pop && !empty) begin
                top_index <= top_index - 1;
                data_out <= stack[top_index];
                full <= 1'b0;
                if (top_index == 3'b001) empty <= 1'b1; // Stack is empty
            end
            if (!pop && top_index > 0) begin
                data_out <= stack[top_index - 1];
            end
        end
    end
endmodule