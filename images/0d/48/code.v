module serializer(
    input clk,
    input reset,
    input start,
    input [15:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [3:0] count; // 4-bit counter for 16 bits
    reg [15:0] data; // Register to hold the input data

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            serial_out <= 0;
            done <= 0;
        end else if (start && count < 16) begin
            data <= parallel_in; // Load parallel data
            serial_out <= data[15]; // Output the MSB first
            data <= {data[14:0], 1'b0}; // Shift left
            count <= count + 1; // Increment count
            if (count == 15) begin
                done <= 1; // Set done when last bit is sent
            end else begin
                done <= 0;
            end
        end
    end
endmodule