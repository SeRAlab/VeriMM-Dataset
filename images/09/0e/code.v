module sample_rate_converter(
    input clk,
    input enable,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [1:0] counter;

    always @(posedge clk) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter == 3) begin
                data_out <= data_in; // Downsample by 4
                counter <= 0; // Reset counter
            end
        end
    end
endmodule