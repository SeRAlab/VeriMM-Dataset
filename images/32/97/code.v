module stack #(
    parameter WIDTH = 8,
    parameter DEPTH = 4
)(
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [WIDTH-1:0] stack_mem [0:DEPTH-1];
    reg [3:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            is_empty <= 1;
            is_full <= 0;
        end else begin
            if (push && !is_full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                is_empty <= 0;
                if (top + 1 == DEPTH) is_full <= 1;
            end 
            if (pop && !is_empty) begin
                top <= top - 1;
                data_out <= stack_mem[top-1];
                if (top - 1 == 0) is_empty <= 1;
                is_full <= 0;
            end
            if (!is_empty) begin
                data_out <= stack_mem[top-1];
            end
        end
    end
endmodule