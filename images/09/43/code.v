module stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack_mem[3:0]; // 4 entries stack
    reg [1:0] sp; // stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 2'b00;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (push && !full) begin
                stack_mem[sp] <= data_in;
                sp <= sp + 1;
            end
            if (pop && !empty) begin
                sp <= sp - 1;
                data_out <= stack_mem[sp - 1];
            end
            empty <= (sp == 2'b00);
            full <= (sp == 2'b10); // full when sp is 2
        end
    end
endmodule