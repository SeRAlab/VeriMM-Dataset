module top_module(
    input clk,
    input rst_n,
    input [15:0] in,
    input [1:0] select,
    input [7:0] write_addr,
    input [3:0] write_data,
    input [7:0] read_addr,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);reg [3:0] ram [0:7];
reg [15:0] bitwise_result;
reg [7:0] read_data;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_hi <= 8'b0;
        out_lo <= 8'b0;
    end else begin
        case (select)
            2'b00: bitwise_result = in & (in << 1);
            2'b01: bitwise_result = in | (in << 1);
            2'b10: bitwise_result = in ^ (in << 1);
            default: bitwise_result = in;
        endcase

        if (write_addr < 8) begin
            ram[write_addr] <= write_data;
        end

        if (read_addr < 8) begin
            read_data <= ram[read_addr];
        end

        out_hi <= {bitwise_result[15], bitwise_result[13], bitwise_result[11], bitwise_result[9],
                   read_data[3], read_data[2], read_data[1], read_data[0]};
        out_lo <= {bitwise_result[14], bitwise_result[12], bitwise_result[10], bitwise_result[8],
                   read_data[7], read_data[6], read_data[5], read_data[4]};
    end
end

endmodule