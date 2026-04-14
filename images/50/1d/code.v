module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [3:0] write_addr,
    input [7:0] write_data,
    input read_en,
    input [3:0] read_addr,
    output reg [7:0] read_data,
    input [7:0] mux_input_a,
    input [7:0] mux_input_b,
    input [7:0] mux_input_c,
    input [1:0] mux_ctrl,
    output reg [7:0] mux_output,
    output reg [7:0] bitwise_or_output
);// True Dual-Port RAM
reg [7:0] ram [0:15];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 8'b0;
    end else begin
        if (write_en) begin
            ram[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data <= ram[read_addr];
        end
    end
end

// 3-to-4 Multiplexer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mux_output <= 8'b0;
    end else begin
        case (mux_ctrl)
            2'b00: mux_output <= mux_input_a;
            2'b01: mux_output <= mux_input_b;
            2'b10: mux_output <= mux_input_c;
            default: mux_output <= 8'b0;
        endcase
    end
end

// Bitwise OR operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bitwise_or_output <= 8'b0;
    end else begin
        bitwise_or_output <= read_data | mux_output;
    end
end

endmodule