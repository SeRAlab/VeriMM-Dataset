module deserializer (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [7:0] parallel_out,
    output reg valid
);
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            parallel_out <= 8'b00000000;
            valid <= 0;
        end else begin
            if (bit_count < 3'd8) begin
                parallel_out <= {serial_in, parallel_out[7:1]};
                bit_count <= bit_count + 1;
                valid <= 0;
            end else begin
                valid <= 1; // Indicate that the output is valid after 8 bits
            end
        end
    end
endmodule