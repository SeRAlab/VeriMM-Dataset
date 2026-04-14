module stack #(parameter DEPTH = 4, parameter WIDTH = 8) (
    input clk,
    input rst,
    input push,
    input pop,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg empty,
    output reg full
);

reg [WIDTH-1:0] stack_mem [0:DEPTH-1];
reg [3:0] top;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        top <= 0;
        empty <= 1;
        full <= 0;
        data_out <= 0;
    end else begin
        if (push) begin
            if (!full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 0;
                if (top == DEPTH - 1) full <= 1;
            end
        end
        
        if (pop) begin
            if (!empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                full <= 0;
                if (top == 1) empty <= 1;
            end
        end
        
        if (top > 0)
            data_out <= stack_mem[top - 1]; // peek
    end
end
endmodule