module deserializer (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] count; // 3-bit counter for 8 bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 8'b0;
            count <= 3'b0;
        end else begin
            if (count < 3'd8) begin
                parallel_out[count] <= serial_in; // Shift in serial bit
                count <= count + 1'b1; // Increment count
            end
        end
    end
endmodule