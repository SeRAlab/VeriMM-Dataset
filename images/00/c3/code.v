module stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty
);

    reg [7:0] stack_mem [0:15]; // Stack memory
    reg [3:0] sp; // Stack Pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            empty <= 1;
        end else begin
            if (push && sp < 16) begin
                stack_mem[sp] <= data_in;
                sp <= sp + 1;
                empty <= 0;
            end
            if (pop && sp > 0) begin
                sp <= sp - 1;
                data_out <= stack_mem[sp-1];
                if (sp == 1) empty <= 1; // Check if stack becomes empty
            end
        end
    end
endmodule