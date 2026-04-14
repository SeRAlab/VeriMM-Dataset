module deserializer (
    input wire clk,
    input wire reset,
    input wire serialized_data,
    output reg [7:0] deserialized_data,
    output reg data_ready
);
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            deserialized_data <= 8'b0;
            data_ready <= 0;
        end else if (bit_count < 8) begin
            deserialized_data[bit_count] <= serialized_data;
            bit_count <= bit_count + 1;
        end else begin
            data_ready <= 1;
        end
    end
endmodule