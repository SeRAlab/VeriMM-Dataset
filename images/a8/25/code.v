module top_module(
    input clk,
    input rst_n,
    input [7:0] write_data,
    input [7:0] read_addr,
    input [3:0] write_addr,
    input [3:0] in,
    input read_en,
    input write_en,
    output reg [3:0] read_data,
    output out_and,
    output out_or,
    output out_xor,
    output [3:0] functional_output
);// True Dual-Port RAM
reg [3:0] ram [0:7];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 4'b0;
    end else begin
        if (read_en) begin
            read_data <= ram[read_addr];
        end
        if (write_en) begin
            ram[write_addr] <= write_data;
        end
    end
end

// Combinational Circuit
wire [1:0] and_out, or_out, xor_out;

assign and_out[0] = in[0] & in[1];
assign and_out[1] = in[2] & in[3];
assign or_out[0] = in[0] | in[1];
assign or_out[1] = in[2] | in[3];
assign xor_out[0] = in[0] ^ in[1];
assign xor_out[1] = in[2] ^ in[3];

assign out_and = and_out[0] & and_out[1];
assign out_or = or_out[0] | or_out[1];
assign out_xor = xor_out[0] ^ xor_out[1];

// Functional Module
assign functional_output = read_data ^ {out_and, out_or, out_xor, 1'b0};

endmodule