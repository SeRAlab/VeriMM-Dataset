module stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack_mem [7:0]; // stack memory of 8 elements
    reg [2:0] top; // to track the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b000; // reset top
            empty <= 1'b1; // stack is empty
            full <= 1'b0; // stack is not full
            data_out <= 8'b0; // output data
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in; // push data
                top <= top + 1;
                if (top == 3'b111) full <= 1'b1; // stack full
                empty <= 1'b0; // stack not empty
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top]; // pop data
                if (top == 3'b000) empty <= 1'b1; // stack empty
                full <= 1'b0; // stack not full
            end
        end
    end
endmodule