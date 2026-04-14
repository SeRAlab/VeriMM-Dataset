module LIFO_stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack [0:3];
    reg [1:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            empty <= 1;
            full <= 0;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
                empty <= 0;
                if (top + 1 == 4) full <= 1;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top];
                full <= 0;
                if (top == 0) empty <= 1;
            end else if (!empty) begin
                data_out <= stack[top - 1];
            end
        end
    end
endmodule