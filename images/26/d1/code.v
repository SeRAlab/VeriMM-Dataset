module deserializer (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] count; // 3-bit counter to count bits received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            parallel_out <= 8'b00000000;
        end else if (count < 3'b111) begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift left and add new bit
            count <= count + 1;
        end
    end
endmodule