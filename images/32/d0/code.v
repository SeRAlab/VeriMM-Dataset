module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            serial_out <= 1'b0;
            done <= 1'b0;
        end else if (count < 3'b100) begin
            serial_out <= parallel_in[count];
            count <= count + 1;
            done <= (count == 3'b011) ? 1'b1 : 1'b0; // done after 8 bits
        end else begin
            done <= 1'b1; // signal done after all bits are sent
        end
    end
endmodule