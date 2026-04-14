module deserializer (
    input wire clk,
    input wire serial_in,
    output reg [31:0] parallel_out
);
    reg [5:0] count; // 6-bit counter to count up to 32

    always @(posedge clk) begin
        if (count < 32) begin
            parallel_out[count] <= serial_in; // Shift serial input into parallel output
            count <= count + 1; // Increment counter
        end else begin
            count <= 0; // Reset counter after 32 bits
        end
    end
endmodule