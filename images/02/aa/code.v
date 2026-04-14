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
    reg [7:0] stack_mem [0:3];
    reg [1:0] stack_ptr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stack_ptr <= 2'b00;
            empty <= 1'b1;
            full <= 1'b0;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack_mem[stack_ptr] <= data_in;
                stack_ptr <= stack_ptr + 1;
                empty <= 1'b0;
                if (stack_ptr == 2'b11) full <= 1'b1;
            end
            if (pop && !empty) begin
                stack_ptr <= stack_ptr - 1;
                data_out <= stack_mem[stack_ptr - 1];
                if (stack_ptr == 2'b01) empty <= 1'b1;
                full <= 1'b0;
            end
        end
    end
endmodule