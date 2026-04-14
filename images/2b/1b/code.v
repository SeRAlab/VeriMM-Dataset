module deserializer (
    input wire clk,
    input wire valid,
    input wire [7:0] data_in,
    output reg [31:0] data_out,
    output reg data_ready
);
    reg [1:0] count;

    always @(posedge clk) begin
        if (valid) begin
            data_out <= {data_out[23:0], data_in}; // Shift in new data
            count <= count + 1;
            if (count == 2) begin
                data_ready <= 1; // Set data ready after 4 inputs
            end
        end
    end

    always @(negedge clk) begin
        if (count == 3) begin
            count <= 0; // Reset count after 4 inputs
            data_ready <= 0; // Clear data ready signal
        end
    end
endmodule