module deserializer (
    input clk,
    input reset,
    input [7:0] serial_in,
    output reg [31:0] parallel_out
);
    reg [1:0] count; // 2-bit counter to count the number of 8-bit inputs received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            parallel_out <= 32'b0;
        end else if (count < 4) begin
            parallel_out <= (parallel_out << 8) | serial_in; // Shift in the new byte
            count <= count + 1; // Increment the count
        end
    end
endmodule