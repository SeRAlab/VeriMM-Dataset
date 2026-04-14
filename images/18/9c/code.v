module deserializer (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [7:0] parallel_out,
    output reg data_valid
);
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            parallel_out <= 8'b00000000;
            data_valid <= 1'b0;
        end else begin
            if (bit_count < 3'b111) begin
                parallel_out[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
                data_valid <= 1'b0;
            end 
            if (bit_count == 3'b111) begin
                data_valid <= 1'b1; // Indicate that data is valid
            end
        end
    end
endmodule