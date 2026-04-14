module sample_rate_converter(
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [7:0] data_out
);

reg [1:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        data_out <= 0;
    end else begin
        if (count == 1) begin
            data_out <= data_in; // Output on every 2nd clock cycle
        end
        count <= count + 1;
        if (count == 2) begin
            count <= 0; // Reset count after 2 cycles
        end
    end
end

endmodule