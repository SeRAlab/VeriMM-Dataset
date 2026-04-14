module top_module(
    reset,
    clk,
    address0,
    ce0,
    we0,
    d0,
    q0,
    address1,
    ce1,
    we1,
    d1,
    q1);parameter DataWidth = 32'd8;
parameter AddressRange = 32'd5760;
parameter AddressWidth = 32'd13;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
input we0;
input[DataWidth - 1:0] d0;
output[DataWidth - 1:0] q0;
input[AddressWidth - 1:0] address1;
input ce1;
input we1;
input[DataWidth - 1:0] d1;
output[DataWidth - 1:0] q1;

reg[DataWidth - 1:0] line_buffer0[AddressRange-1:0];
reg[DataWidth - 1:0] line_buffer1[AddressRange-1:0];
reg[DataWidth - 1:0] line_buffer2[AddressRange-1:0];

reg[DataWidth - 1:0] pixel[2:0];
reg[DataWidth - 1:0] new_pixel;
reg[AddressWidth - 1:0] current_address0;
reg[AddressWidth - 1:0] current_address1;
reg[AddressWidth - 1:0] current_address2;

always@(posedge clk) begin
    if(reset) begin
        current_address0 <= 0;
        current_address1 <= 0;
        current_address2 <= 0;
    end else begin
        current_address0 <= current_address0 + 1;
        current_address1 <= current_address1 + 1;
        current_address2 <= current_address2 + 1;
        pixel[0] <= line_buffer0[current_address0+1];
        pixel[1] <= line_buffer0[current_address0];
        pixel[2] <= line_buffer0[current_address0-1];
        pixel[0] <= line_buffer1[current_address1+1];
        pixel[1] <= line_buffer1[current_address1];
        pixel[2] <= line_buffer1[current_address1-1];
        new_pixel <= (pixel[0] + pixel[1] + pixel[2] + line_buffer0[current_address0] + line_buffer1[current_address1] + line_buffer2[current_address2]) / 9;
        line_buffer2[current_address2] <= new_pixel;
    end
end

assign q0 = line_buffer0[address0];
assign q1 = line_buffer1[address1];

always@(posedge clk) begin
    if(we0) begin
        line_buffer0[address0] <= d0;
    end
    if(we1) begin
        line_buffer1[address1] <= d1;
    end
end

endmodule