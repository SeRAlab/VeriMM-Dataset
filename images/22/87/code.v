module deserializer (
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [31:0] data_out
);

reg [1:0] counter; // Counter to track the number of clock cycles

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 32'b0;
        counter <= 2'b0;
    end else begin
        if (counter < 2) begin
            data_out <= {data_out[15:0], data_in}; // Shift in data
            counter <= counter + 1;
        end
    end
end

endmodule