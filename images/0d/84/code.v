module sample_rate_converter (
    input wire clk,
    input wire rst,
    input wire in_valid,
    input wire [7:0] in_data,
    output reg out_valid,
    output reg [7:0] out_data
);

reg [1:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        out_valid <= 0;
        out_data <= 0;
    end else begin
        if (in_valid) begin
            out_data <= in_data; // Pass data to output
            out_valid <= 1;      // Mark output as valid
            count <= count + 1;  // Increment count
        end

        // On every input valid, output two samples
        if (count == 1) begin
            out_valid <= 0; // Deactivate output valid after two samples
            count <= 0;     // Reset count
        end
    end
end

endmodule