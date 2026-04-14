module top_module(
    input clk,
    input rst,
    input ss,
    input mosi,
    output miso,
    input sck,
    output done,
    input [7:0] din,
    output reg [7:0] dout
);reg [7:0] data;
reg [2:0] bit_count;
reg [7:0] shift_reg;
reg done_reg;
reg mosi_reg;
reg ss_reg;
reg sck_reg;
reg miso_reg;

assign miso = miso_reg;
assign done = done_reg;

// dout assignment changed to always block
always @(posedge clk) begin
    if (rst) begin
        data <= 8'b0;
        bit_count <= 3'b0;
        shift_reg <= 8'b0;
        done_reg <= 1'b0;
        mosi_reg <= 1'b0;
        ss_reg <= 1'b1;
        sck_reg <= 1'b0;
        miso_reg <= 1'b1;
        dout <= 8'b0;  // Initialize dout
    end else begin
        if (!ss_reg && ss) begin
            data <= din;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else if (!sck_reg && sck) begin
            shift_reg <= {shift_reg[6:0], mosi_reg};
            bit_count <= bit_count + 1'b1;
            if (bit_count == 3'b111) begin
                dout <= shift_reg;  // Assign dout at the end of the transfer
                done_reg <= 1'b1;
                shift_reg <= 8'b0;
                bit_count <= 3'b0;
            end
        end
        mosi_reg <= mosi;
        ss_reg <= ss;
        sck_reg <= sck;
        miso_reg <= shift_reg[7];
    end
end

endmodule