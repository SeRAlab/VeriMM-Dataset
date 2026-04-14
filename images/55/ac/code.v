module simple_register(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 8'b00000000;
    end else if (en) begin
        data_out <= data_in;
    end
end

endmodule