module register_8bit(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 8'b00000000;
    end
    else if (load) begin
        data_out <= data_in;
    end
end

endmodule