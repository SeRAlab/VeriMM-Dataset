module stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] stack_mem [3:0];
    reg [1:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            empty <= 1'b1;
            full <= 1'b0;
            data_out <= 8'b00000000;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0;
                if (top == 2'b11)
                    full <= 1'b1;
            end

            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                if (top == 2'b01)
                    empty <= 1'b1;
                full <= 1'b0;
            end
        end
    end
endmodule