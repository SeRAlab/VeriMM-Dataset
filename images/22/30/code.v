module stack(
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    parameter DEPTH = 8;
    reg [7:0] stack_mem [0:DEPTH-1];
    reg [3:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 0;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 0;
                if (top + 1 == DEPTH) begin
                    full <= 1;
                end
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                if (top == 1) begin
                    empty <= 1;
                end
                full <= 0;
            end
        end
    end
endmodule