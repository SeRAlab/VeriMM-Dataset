module serializer (
    input wire clk,
    input wire valid,
    input wire [31:0] data_in,
    output reg serial_out
);
    reg [5:0] bit_counter;

    always @(posedge clk) begin
        if (valid) begin
            if (bit_counter < 32) begin
                serial_out <= data_in[31 - bit_counter];
                bit_counter <= bit_counter + 1;
            end else begin
                bit_counter <= 0;
            end
        end
    end
endmodule