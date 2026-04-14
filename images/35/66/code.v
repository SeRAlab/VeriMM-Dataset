module sd_card_controller(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] sd_data,
    output reg [7:0] data_out
);

reg [7:0] data_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_reg <= 8'b0;
        data_out <= 8'b0;
    end else if (en) begin
        data_reg <= sd_data;
        data_out <= data_reg;
    end
end

endmodule