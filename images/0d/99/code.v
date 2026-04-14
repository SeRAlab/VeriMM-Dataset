module stack(
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack_mem[0:15]; // 16 entries for 8-bit data
    reg [3:0] sp; // stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            empty <= 1;
            full <= 0;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack_mem[sp] <= data_in;
                sp <= sp + 1;
            end
            if (pop && !empty) begin
                sp <= sp - 1;
                data_out <= stack_mem[sp - 1];
            end
            
            empty <= (sp == 0);
            full <= (sp == 16);
        end
    end
endmodule