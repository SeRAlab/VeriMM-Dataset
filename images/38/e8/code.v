module stack (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input push,
    input pop,
    output reg [7:0] data_out,
    output reg is_empty
);
    parameter STACK_SIZE = 8;
    reg [7:0] stack_array[0:STACK_SIZE-1];
    reg [3:0] top;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            top <= 0;
            is_empty <= 1;
        end else begin
            if (push && (top < STACK_SIZE)) begin
                stack_array[top] <= data_in;
                top <= top + 1;
                is_empty <= (top + 1 == 0);
            end
            if (pop && (top > 0)) begin
                top <= top - 1;
                data_out <= stack_array[top];
                is_empty <= (top - 1 == 0);
            end
        end
    end
endmodule