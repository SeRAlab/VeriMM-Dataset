module serializer (
    input wire clk,
    input wire reset,
    input wire [31:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [5:0] count; // 6 bits to count from 0 to 31

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            serial_out <= 0;
            done <= 0;
        end else if (count < 32) begin
            serial_out <= parallel_in[count];
            count <= count + 1;
            done <= (count == 31) ? 1 : 0; // Set done when last bit is sent
        end
    end
endmodule