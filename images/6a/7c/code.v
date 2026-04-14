module top_module(
    input clk,
    input rst_n,
    input [3:0] in,
    output reg [1:0] pos,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    output reg [3:0] read_data,
    output reg [5:0] final_output
);// Binary to Gray code converter
wire [1:0] gray_code;
assign gray_code = (pos >> 1) ^ pos;

// 4-bit priority encoder
reg [1:0] priority_encoder;
always @(in) begin
    if (in[3]) priority_encoder = 2'b11;
    else if (in[2]) priority_encoder = 2'b10;
    else if (in[1]) priority_encoder = 2'b01;
    else if (in[0]) priority_encoder = 2'b00;
    else priority_encoder = 2'b00;
end

// True dual-port RAM
reg [3:0] ram [0:7];
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            ram[i] <= 4'b0000;
        end
    end else begin
        if (write_en) begin
            ram[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data <= ram[read_addr];
        end
    end
end

// Additional functional module
always @(posedge clk) begin
    pos <= priority_encoder;
    final_output <= {gray_code, read_data};
end

endmodule