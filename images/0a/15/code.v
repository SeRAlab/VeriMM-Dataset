module flash_memory (
    input clk,
    input write,
    input erase,
    output reg data_out
);
    always @(posedge clk) begin
        if (write) begin
            data_out <= 1'b1;  // Write operation
        end else if (erase) begin
            data_out <= 1'b0;  // Erase operation
        end
    end
endmodule