module serializer(
    input clk,
    input reset,
    input start,
    input [15:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [3:0] count;
    reg [15:0] data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'd0;
            serial_out <= 1'b0;
            done <= 1'b0;
        end else if (start) begin
            data <= parallel_in;
            count <= 4'd15; // Start with 15 bits to shift
            done <= 1'b0;
        end else if (count > 0) begin
            serial_out <= data[count]; // Shift out the bit
            count <= count - 1; // Decrement the count
        end else if (count == 0) begin
            serial_out <= 1'b0; // Ensure serial_out is low after done
            done <= 1'b1; // Indicate completion
        end
    end
endmodule