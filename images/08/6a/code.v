module deserializer (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [31:0] data_out
);

    reg [4:0] count; // Counter to keep track of the number of clock cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0; // Clear output on reset
            count <= 5'b0; // Reset count
        end else if (count < 5'd4) begin
            data_out <= {data_out[23:0], data_in}; // Shift in new data
            count <= count + 1; // Increment count
        end
    end
endmodule