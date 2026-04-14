module sample_rate_converter(
    input wire clk_in,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg clk_out
);
    reg [1:0] count;

    always @(posedge clk_in) begin
        count <= count + 1;
        if (count == 2) begin
            data_out <= data_in;
            clk_out <= ~clk_out; // Toggle output clock
            count <= 0; // Reset count
        end
    end

    initial begin
        clk_out = 0; // Initialize output clock
        count = 0; // Initialize count
    end
endmodule