module sample_rate_converter(
    input clk,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [1:0] count;

    always @(posedge clk) begin
        count <= count + 1;
        if (count == 2'b01) begin
            data_out <= data_in;
        end
    end
endmodule