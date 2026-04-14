module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 3'b000;
            serial_out <= 1'b0;
        end else begin
            serial_out <= parallel_in[bit_index];
            if (bit_index < 3'b111)
                bit_index <= bit_index + 1;
        end
    end
endmodule