module deserializer (
    input wire clk,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] count; // 3-bit counter to count the bits

    always @(posedge clk) begin
        if (count < 8) begin
            parallel_out[count] <= serial_in; // Shift in the serial data
            count <= count + 1; // Increment the counter
        end
    end

    always @(posedge clk) begin
        if (count == 8) begin
            count <= 0; // Reset the counter after 8 bits are received
        end
    end
endmodule