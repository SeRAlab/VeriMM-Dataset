module binary_counter(
    input clk,
    input reset,
    output reg [1:0] count
);

    // Always block triggered on the rising edge of the clock or reset signal
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;  // Asynchronous reset to zero
        end else begin
            count <= count + 1;  // Increment counter
        end
    end

endmodule