module flash_memory_cell (
    input clk,
    input reset,
    input program,
    input erase,
    output reg data
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data <= 0;
        end else if (program && !erase) begin
            data <= 1;
        end else if (erase && !program) begin
            data <= 0;
        end
    end
endmodule