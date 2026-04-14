module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    input [3:0] mux_in_0,
    input [3:0] mux_in_1,
    input [3:0] mux_in_2,
    input [3:0] mux_in_3,
    input [1:0] mux_sel,
    output reg [3:0] out
);reg [3:0] ram [0:7];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0;
    end else begin
        if (write_en) begin
            ram[write_addr[2:0]] <= write_data;
        end
        if (read_en) begin
            case (mux_sel)
                2'b00: out <= ram[read_addr[2:0]];
                2'b01: out <= mux_in_0;
                2'b10: out <= mux_in_1;
                2'b11: out <= mux_in_2;
            endcase
        end
    end
end

endmodule