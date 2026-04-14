module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    output reg [3:0] read_data,
    input [3:0] in,
    output [3:0] out1,
    output [3:0] out2,
    output [3:0] and_output
);reg [3:0] mem [7:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 4'b1111;
    end else begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data <= mem[read_addr];
        end
    end
end

wire [3:0] shifted_in;
assign shifted_in = {in[2:0], 1'b0};

wire [3:0] mux_out;
assign mux_out = (write_en) ? in : shifted_in;

assign out1 = in;
assign out2 = mux_out;

wire [3:0] and_out;
assign and_out = read_data & mux_out;

assign and_output = and_out;

endmodule