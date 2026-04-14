module deserializer (
    input clk,
    input rst,
    input [1:0] serial_in,
    output reg [15:0] parallel_out
);
    reg [3:0] count; // Count the number of clock cycles

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            parallel_out <= 0;
        end else if (count < 8) begin
            parallel_out <= {parallel_out[13:0], serial_in}; // Shift in the new 2 bits
            count <= count + 1;
        end
    end
endmodule