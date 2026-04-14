module top_module(
    input clk,
    input rst_n,
    input [15:0] data_in,
    output reg [7:0] max_value,
    output reg [7:0] max_index
);reg [7:0] data_array [15:0];
integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        max_value <= 8'h0;
        max_index <= 8'h0;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            data_array[i] <= data_in[i];
        end

        max_value <= data_array[0];
        max_index <= 8'h0;

        for (i = 1; i < 16; i = i + 1) begin
            if (data_array[i] > max_value) begin
                max_value <= data_array[i];
                max_index <= i;
            end
        end
    end
end

endmodule