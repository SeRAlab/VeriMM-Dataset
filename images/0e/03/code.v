module flash_memory_cell (
    input wire clk,
    input wire program,
    input wire erase,
    output reg stored_value
);

always @(posedge clk) begin
    if (program) begin
        stored_value <= 1'b1;
    end else if (erase) begin
        stored_value <= 1'b0;
    end
end

endmodule