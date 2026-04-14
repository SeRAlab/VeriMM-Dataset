module sample_rate_converter(
    input wire clk_in,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [1:0] count;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000;
            count <= 2'b00;
        end else begin
            count <= count + 1;
            if (count == 2'b01) begin
                data_out <= data_in;
            end
        end
    end
endmodule