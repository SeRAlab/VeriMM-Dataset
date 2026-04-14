module sample_rate_converter (
    input clk,
    input reset,
    input data_in,
    output reg data_out
);

reg [1:0] sample_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sample_count <= 0;
        data_out <= 0;
    end else begin
        if (sample_count == 1) begin
            data_out <= data_in; // Output every second sample
            sample_count <= 0;    // Reset count
        end else begin
            data_out <= data_out; // Maintain previous output
            sample_count <= sample_count + 1; // Increment count
        end
    end
end

endmodule