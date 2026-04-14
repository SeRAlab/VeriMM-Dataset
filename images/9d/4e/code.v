module top_module(
    input clk,
    input reset,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    input [7:0] data_in,
    input [1:0] shift_direction,
    input load,
    output [7:0] data_out
);reg [3:0] ram [0:7];
reg [7:0] shift_reg;
wire [3:0] read_data;

always @(posedge clk) begin
    if (write_en) begin
        ram[write_addr] <= write_data;
    end
end

assign read_data = (read_en) ? ram[read_addr] : 4'b0;

always @(negedge clk) begin
    if (reset) begin
        shift_reg <= 8'h34;
    end else if (load) begin
        shift_reg <= data_in;
    end else begin
        case (shift_direction)
            2'b00: shift_reg <= shift_reg;
            2'b01: shift_reg <= {shift_reg[6:0], 1'b0};
            2'b10: shift_reg <= {1'b0, shift_reg[7:1]};
            2'b11: shift_reg <= shift_reg;
        endcase
    end
end

assign data_out = read_data ^ shift_reg[3:0];

endmodule