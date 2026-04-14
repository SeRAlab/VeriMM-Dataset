module serializer (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] parallel_in,
    output reg serial_out,
    output reg valid
);
    reg [5:0] bit_counter; // 0 to 31 for 32 bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 0;
            serial_out <= 0;
            valid <= 0;
        end else if (start) begin
            if (bit_counter < 32) begin
                serial_out <= parallel_in[31 - bit_counter];
                valid <= 1;
                bit_counter <= bit_counter + 1;
            end else begin
                valid <= 0; // Serialization complete
            end
        end
    end
endmodule