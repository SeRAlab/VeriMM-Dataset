module decrementer_8bit(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] data_out
    );

always @(posedge clk) begin
    if (rst) begin
        data_out <= 8'b0;
    end
    else begin
        data_out <= data_in - 1'b1;
    end
end

endmodule