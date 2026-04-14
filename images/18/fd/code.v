module flash_memory (
    input wire clk,
    input wire program,
    input wire erase,
    output reg stored_value
);
    always @(posedge clk) begin
        if (erase) begin
            stored_value <= 1'b0; // Erase operation sets the value to 0
        end else if (program) begin
            stored_value <= 1'b1; // Program operation sets the value to 1
        end
        // Read operation is handled implicitly by outputting stored_value
    end
endmodule