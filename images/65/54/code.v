module top_module(
    input clk,
    input rst,
    input data_in,
    input crc_en,
    output reg [15:0] crc_out
);reg [15:0] shift_reg;
reg crc_sample_now;
reg crc_reset;
wire [15:0] computed_crc;

assign computed_crc = (crc_sample_now) ? shift_reg ^ 16'hAE3C : 16'h0000;

always @(posedge clk) begin
    if (rst) begin
        shift_reg <= 16'h0000;
        crc_sample_now <= 0;
        crc_reset <= 1;
        crc_out <= 16'h0000;
    end else begin
        crc_reset <= 0;
        if (crc_en) begin
            shift_reg <= {shift_reg[14:0], data_in};
            crc_sample_now <= 1;
        end else begin
            crc_sample_now <= 0;
        end
        crc_out <= computed_crc;
    end
end

endmodule