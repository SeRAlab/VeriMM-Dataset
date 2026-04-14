module deserializer (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] count; // 3 bits to count 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            parallel_out <= 8'b0;
        end else if (count < 8) begin
            parallel_out[count] <= serial_in;
            count <= count + 1;
        end
    end
endmodule