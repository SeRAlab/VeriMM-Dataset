module gray_code_counter(
    input clk,
    input reset,
    output reg [2:0] q
);

    reg [2:0] binary_counter;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            binary_counter <= 3'b000;
            q <= 3'b000;
        end else begin
            // Increment the binary counter
            binary_counter <= binary_counter + 1;
            // Convert binary to Gray code
            q <= binary_counter ^ (binary_counter >> 1);
        end
    end

endmodule