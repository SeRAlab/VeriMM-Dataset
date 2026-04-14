module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] count; // 3-bit counter for 8 bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            serial_out <= 1'b0;
        end else begin
            if (count < 3'b111) begin // If count is less than 8
                serial_out <= parallel_in[count]; // Output the current bit
                count <= count + 1; // Increment the counter
            end
        end
    end
endmodule