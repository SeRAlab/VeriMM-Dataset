module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 3'b000;
            serial_out <= 1'b0;
        end else begin
            if (bit_counter < 3'b111) begin
                serial_out <= data_in[7 - bit_counter];
                bit_counter <= bit_counter + 1;
            end
        end
    end
endmodule