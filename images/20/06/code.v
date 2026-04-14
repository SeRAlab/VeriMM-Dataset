module flash_memory_cell (
    input wire clk,
    input wire reset,
    input wire write,
    output reg read
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            read <= 1'b0; // Erased state
        end else if (write) begin
            read <= 1'b1; // Programmed state
        end
    end
endmodule